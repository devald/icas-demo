variable "eks_cluster_name" {
  description = "Name of the EKS cluster to connect to."
  type        = string

  validation {
    condition     = length(var.eks_cluster_name) > 0
    error_message = "EKS cluster name must not be empty."
  }
}

variable "eks_cluster_endpoint" {
  description = "API server endpoint URL of the EKS cluster."
  type        = string

  validation {
    condition     = can(regex("^https://", var.eks_cluster_endpoint))
    error_message = "EKS cluster endpoint must start with 'https://'."
  }
}

variable "eks_ca_data" {
  description = "Base64-encoded certificate authority data for the EKS cluster."
  type        = string

  validation {
    condition     = can(base64decode(var.eks_ca_data))
    error_message = "EKS CA data must be valid base64-encoded string."
  }
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket where the crawler job will upload the downloaded HTML content."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.s3_bucket_name))
    error_message = "S3 bucket name must be 3–63 characters long, lowercase, and may include numbers, dots, and hyphens."
  }
}

variable "target_website_url" {
  description = "The URL of the website that the crawler job will download and upload to the S3 bucket."
  type        = string
  default     = "https://terragrunt.gruntwork.io"

  validation {
    condition     = can(regex("^https?://", var.target_website_url))
    error_message = "Target website URL must start with 'http://' or 'https://'."
  }
}
