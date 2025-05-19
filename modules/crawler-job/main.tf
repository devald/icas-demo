provider "kubernetes" {
  host                   = var.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(var.eks_ca_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
    command     = "aws"
  }
}

resource "kubernetes_job_v1" "crawler" {
  metadata {
    name = "crawler"
    labels = {
      app = "web-crawler"
    }
  }

  spec {
    backoff_limit = 0

    template {
      metadata {
        labels = {
          app = "web-crawler"
        }
      }

      spec {
        restart_policy = "Never"

        container {
          name    = "crawler"
          image   = "amazon/aws-cli:2.27.17"
          command = ["/bin/sh", "-c"]
          args = [
            <<-EOT
              curl -s ${var.target_website_url} -o /tmp/page.html && \
              aws s3 cp /tmp/page.html s3://${var.s3_bucket_name}/page.html
            EOT
          ]
        }
      }
    }
  }

  wait_for_completion = true
  timeouts {
    create = "2m"
    delete = "2m"
    update = "2m"
  }
}
