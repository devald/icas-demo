output "irsa_role_arn" {
  description = "IAM role ARN used by the Kubernetes service account"
  value       = aws_iam_role.crawler_irsa_role.arn
}
