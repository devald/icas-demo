locals {
  roles_by_name = { for role in var.oidc_roles : role.name => role }
}

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = var.thumbprint_list
}

data "aws_iam_policy_document" "oidc_assume" {
  for_each = local.roles_by_name

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${each.value.github_owner}/${each.value.github_repo}:*"]
    }
  }
}

resource "aws_iam_role" "oidc_roles" {
  for_each = local.roles_by_name

  name                 = each.value.name
  assume_role_policy   = data.aws_iam_policy_document.oidc_assume[each.key].json
  max_session_duration = var.max_session_duration
}

data "aws_iam_policy_document" "role_policy" {
  for_each = local.roles_by_name

  statement {
    sid       = each.value.role_policy_sid
    effect    = "Allow"
    actions   = each.value.iam_actions
    resources = ["*"]
  }
}

resource "aws_iam_policy" "role_policy" {
  for_each = local.roles_by_name

  name        = "${each.key}-policy"
  description = "Policy for GitHub OIDC role ${each.key}"
  policy      = data.aws_iam_policy_document.role_policy[each.key].json
}

resource "aws_iam_role_policy_attachment" "role_attach" {
  for_each = local.roles_by_name

  role       = aws_iam_role.oidc_roles[each.key].name
  policy_arn = aws_iam_policy.role_policy[each.key].arn

  depends_on = [
    aws_iam_role.oidc_roles,
    aws_iam_policy.role_policy
  ]
}
