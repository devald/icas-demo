terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-s3-bucket?ref=v4.8.0"
}

include {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

locals {
  name = format("%s-%s-%s", include.locals.environment, include.locals.component, get_aws_account_id())
}

inputs = {
  bucket = local.name
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  # Allow bucket deletion with objects for end-to-end testing purposes
  force_destroy = true
}
