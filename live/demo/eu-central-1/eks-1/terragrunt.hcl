terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-eks?ref=v20.36.0"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

dependencies {
  paths = ["../vpc-1"]
}

dependency "vpc-1" {
  config_path = "../vpc-1"

  mock_outputs = {
    vpc_id = "vpc-0abc1234def567890"
    private_subnets = [
      "fake-subnet-1",
      "fake-subnet-2",
      "fake-subnet-3",
    ]
  }
}

locals {
  name = "${include.root.locals.environment}-${include.root.locals.component}"
}

inputs = {
  cluster_name    = local.name
  cluster_version = "1.32"

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = dependency.vpc-1.outputs.vpc_id
  subnet_ids = dependency.vpc-1.outputs.private_subnets
}
