terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v5.21.0"
}

include {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

dependencies {
  paths = ["../aws-data"]
}

dependency "aws-data" {
  config_path = "../aws-data"

  mock_outputs = {
    available_aws_availability_zones_names = [
      "fake-zone-a",
      "fake-zone-b",
      "fake-zone-c",
    ]
  }
}

locals {
  cidr = "10.0.0.0/16"
  name = "${include.locals.environment}-${include.locals.component}"
}

inputs = {
  azs  = [for v in dependency.aws-data.outputs.available_aws_availability_zones_names : v]
  name = local.name
  cidr = local.cidr

  private_subnets = [for k, v in dependency.aws-data.outputs.available_aws_availability_zones_names : cidrsubnet(local.cidr, 6, k)]

  public_subnets = [for k, v in dependency.aws-data.outputs.available_aws_availability_zones_names : cidrsubnet(local.cidr, 8, k + 100)]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_support   = true
  enable_dns_hostnames = true

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
}
