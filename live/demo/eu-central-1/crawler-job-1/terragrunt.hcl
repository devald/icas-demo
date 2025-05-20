terraform {
  source = "${get_path_to_repo_root()}/modules/crawler-job"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

dependencies {
  paths = ["../eks-1", "../crawler-s3-1"]
}

dependency "eks-1" {
  config_path = "../eks-1"

  mock_outputs = {
    cluster_name                       = "fake-cluster-name"
    cluster_endpoint                   = "https://fake-cluster-endpoint"
    cluster_certificate_authority_data = base64encode("fake-ca-data")
    oidc_provider_arn                  = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.fake-region.amazonaws.com/id/FAKEOIDC"
    oidc_provider                      = "oidc.eks.fake-region.amazonaws.com/id/FAKEOIDC"
  }
}

dependency "crawler-s3-1" {
  config_path = "../crawler-s3-1"

  mock_outputs = {
    s3_bucket_id  = "fake-bucket-name"
    s3_bucket_arn = "arn:aws:s3:::mock-crawler-bucket"
  }
}

locals {
  name = "${include.root.locals.environment}-${include.root.locals.component}"
}

inputs = {
  eks_cluster_name      = dependency.eks-1.outputs.cluster_name
  eks_cluster_endpoint  = dependency.eks-1.outputs.cluster_endpoint
  eks_ca_authority_data = dependency.eks-1.outputs.cluster_certificate_authority_data

  name                 = local.name
  namespace            = local.name
  service_account_name = local.name

  oidc_provider_arn = dependency.eks-1.outputs.oidc_provider_arn
  oidc_provider     = dependency.eks-1.outputs.oidc_provider

  s3_bucket_id  = dependency.crawler-s3-1.outputs.s3_bucket_id
  s3_bucket_arn = dependency.crawler-s3-1.outputs.s3_bucket_arn

  target_website_url = "https://terragrunt.gruntwork.io"
}
