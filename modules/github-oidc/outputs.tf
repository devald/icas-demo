output "oidc_provider_arn" {
  description = "Outputs the ARN of the AWS IAM OpenID Connect provider configured with GitHub."
  value       = aws_iam_openid_connect_provider.github.arn
}

output "oidc_role_arns" {
  description = "Returns a map of ARNs for the IAM roles associated with the specified OIDC provider, keyed by role name. These roles are defined in `aws_iam_role.oidc_roles`."
  value = {
    for k, v in aws_iam_role.oidc_roles : k => v.arn
  }
}
