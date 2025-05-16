# ------------------------------------------------------------------------------
# Terragrunt Root Configuration (root.hcl)
#
# This file defines shared configuration for all modules, including:
# - Backend settings (S3 + DynamoDB)
# - AWS provider injection
# - Dynamic environment, region, and component detection based on folder structure
# - Common tagging
#
# Folder structure expected: live/<environment>/<region>/<component>
# Example: live/demo/eu-central-1/vpc
#
# From this, the following values are extracted dynamically:
#   local.environment = "demo"
#   local.region      = "eu-central-1"
#   local.component   = "vpc"
#
# These values control:
# - The AWS profile used
# - The backend S3 key and tags
# - The provider configuration
# - Optional tag injection
#
# This allows Terragrunt to be DRY and scalable without repeating per-env logic.
# ------------------------------------------------------------------------------
terraform_version_constraint  = "~> 1.11.4"
terragrunt_version_constraint = "~> 0.78.1"

locals {
  path_parts = split("/", path_relative_to_include())

  environment = local.path_parts[1]
  region      = local.path_parts[2]
  component   = local.path_parts[3]

  aws_profile = "${local.environment}-profile"
}

remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }

  config = {
    encrypt        = true
    region         = local.region
    key            = format("%s/terraform.tfstate", path_relative_to_include())
    bucket         = format("terraform-states-%s", get_aws_account_id())
    dynamodb_table = format("terraform-states-%s", get_aws_account_id())
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region  = "${local.region}"
  profile = "${local.aws_profile}"

  default_tags {
    tags = {
      Environment = "${local.environment}"
      Region      = "${local.region}"
      Component   = "${local.component}"
      ManagedBy   = "terragrunt"
    }
  }
}
EOF
}
