terraform {
  source = "${get_path_to_repo_root()}/modules/github-oidc"
}

include "root" {
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
        "s3:*",
        "iam:PassRole",
        "iam:ListRoles",
        "iam:GetRole",
        "iam:CreateServiceLinkedRole",
        "iam:GetPolicy",
        "iam:GetOpenIDConnectProvider",
        "iam:ListOpenIDConnectProviders",
        "iam:ListRolePolicies",
        "logs:DescribeLogGroups",
        "eks:*",
        "ec2:*",
        "dynamodb:*"
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
