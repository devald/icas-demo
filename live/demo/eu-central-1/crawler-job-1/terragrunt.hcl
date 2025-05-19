terraform {
  source = "${get_path_to_repo_root()}/modules/crawler-job"
}

include {
  path = find_in_parent_folders("root.hcl")
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
  }
}

dependency "crawler-s3-1" {
  config_path = "../crawler-s3-1"

  mock_outputs = {
    s3_bucket_id = "fake-bucket-name"
  }
}

inputs = {
  eks_cluster_name     = dependency.eks-1.outputs.cluster_name
  eks_cluster_endpoint = dependency.eks-1.outputs.cluster_endpoint
  eks_ca_data          = dependency.eks-1.outputs.cluster_certificate_authority_data
  s3_bucket_name       = dependency.crawler-s3-1.outputs.s3_bucket_id
}
