variable "eks_cluster_name" {
  description = "Name of the EKS cluster to connect to."
  type        = string
}

variable "eks_cluster_endpoint" {
  description = "API server endpoint URL of the EKS cluster."
  type        = string
}

variable "eks_ca_authority_data" {
  description = "Base64-encoded certificate authority data for the EKS cluster."
  type        = string
}

variable "name" {
  description = "Base name used for naming resources like service accounts and jobs."
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for the service account and job."
  type        = string
}

variable "service_account_name" {
  description = "Name of the Kubernetes service account."
  type        = string
}

variable "image" {
  description = "Docker image used in the crawler job container."
  type        = string
  default     = "amazon/aws-cli:2.27.17"
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC provider."
  type        = string
}

variable "oidc_provider" {
  description = "OIDC provider hostname (e.g., oidc.eks.eu-central-1.amazonaws.com/id/EXAMPLE)."
  type        = string
}

variable "s3_bucket_id" {
  description = "S3 bucket name for crawler output."
  type        = string
}

variable "s3_bucket_arn" {
  description = "S3 bucket ARN."
  type        = string
}

variable "target_website_url" {
  description = "URL to be downloaded by the crawler."
  type        = string

  validation {
    condition     = can(regex("^https?://", var.target_website_url))
    error_message = "Target website URL must start with 'http://' or 'https://'."
  }
}
