terraform {
  source = "${get_path_to_repo_root()}/modules/aws-data"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = {}
