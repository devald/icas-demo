output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.github.arn
}

output "oidc_role_arns" {
  value = {
    for k, v in aws_iam_role.oidc_roles : k => v.arn
  }
}

