locals {
  common_labels = {
    "app.kubernetes.io/managed-by" = "terraform"
  }
}

# IAM policy for S3 access
data "aws_iam_policy_document" "crawler_s3_policy" {
  statement {
    sid       = "AllowListBucket"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [var.s3_bucket_arn]
  }

  statement {
    sid       = "AllowObjectAccess"
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["${var.s3_bucket_arn}/*"]
  }
}

resource "aws_iam_policy" "crawler_s3_upload_policy" {
  name        = "${var.name}-upload-policy"
  description = "Policy allowing upload to ${var.s3_bucket_id}"
  policy      = data.aws_iam_policy_document.crawler_s3_policy.json
}

# OIDC trust policy for IRSA
data "aws_iam_policy_document" "crawler_oidc_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.service_account_name}"]
    }
  }
}

# IAM role for IRSA
resource "aws_iam_role" "crawler_irsa_role" {
  name               = "${var.name}-irsa-role"
  assume_role_policy = data.aws_iam_policy_document.crawler_oidc_trust.json
}

resource "aws_iam_role_policy_attachment" "crawler_s3_attach" {
  role       = aws_iam_role.crawler_irsa_role.name
  policy_arn = aws_iam_policy.crawler_s3_upload_policy.arn
}

# Namespace
resource "kubernetes_namespace_v1" "crawler_ns" {
  metadata {
    name   = var.namespace
    labels = local.common_labels
  }
}

# Kubernetes service account
resource "kubernetes_service_account_v1" "crawler_sa" {
  metadata {
    name      = var.service_account_name
    namespace = kubernetes_namespace_v1.crawler_ns.metadata[0].name
    labels    = local.common_labels
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.crawler_irsa_role.arn
    }
  }
}

# Kubernetes Job
resource "kubernetes_job_v1" "crawler_job" {
  metadata {
    name      = "${var.name}-job"
    namespace = kubernetes_namespace_v1.crawler_ns.metadata[0].name
    labels    = local.common_labels
  }

  spec {
    backoff_limit              = 1
    ttl_seconds_after_finished = 300

    template {
      metadata {
        labels = {
          app = "crawler"
        }
      }

      spec {
        restart_policy       = "Never"
        service_account_name = kubernetes_service_account_v1.crawler_sa.metadata[0].name

        container {
          name  = "crawler"
          image = var.image

          command = ["/bin/sh", "-c"]
          args = [
            <<-EOT
              set -e
              curl -s ${var.target_website_url} -o /tmp/page.html
              aws s3 cp /tmp/page.html s3://${var.s3_bucket_id}/page-$(date +%s).html || exit 1
            EOT
          ]
        }
      }
    }
  }
}
