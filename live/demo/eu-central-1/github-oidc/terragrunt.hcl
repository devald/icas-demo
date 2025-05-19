terraform {
  source = "${get_path_to_repo_root()}/modules/github-oidc"
}

include {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  oidc_roles = [
    {
      name         = "github-oidc-terraform"
      github_owner = "devald"
      github_repo  = "icas-demo"
      iam_actions = [
        "sts:GetCallerIdentity",
        "ec2:*",
        "s3:*",
        "eks:*",
        "iam:CreateServiceLinkedRole",
        "iam:PassRole",
        "iam:GetRole",
        "iam:ListRoles"
      ]
    },
    {
      name         = "github-oidc-k8s-deployer"
      github_owner = "devald"
      github_repo  = "icas-demo"
      iam_actions = [
        "sts:GetCallerIdentity",
        "eks:DescribeCluster",
        "eks:DescribeNodegroup",
        "eks:ListNodegroups",
        "eks:ListClusters",
        "iam:PassRole"
      ]
    }
  ]
}
