variable "oidc_roles" {
  description = "List of OIDC IAM role definitions, each including name, GitHub repo, and IAM actions."
  type = list(object({
    name            = string
    github_owner    = string
    github_repo     = string
    iam_actions     = list(string)
    role_policy_sid = optional(string, "GitHubOIDCAccess")
  }))

  validation {
    condition     = length(var.oidc_roles) > 0
    error_message = "At least one OIDC role definition must be provided."
  }
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds (must be between 3600 and 43200)."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "Maximum session duration must be between 3600 and 43200 seconds."
  }
}

variable "thumbprint_list" {
  description = "List of GitHub OIDC TLS certificate SHA-1 thumbprints (each 40 characters)."
  type        = list(string)
  default     = ["6938fd4d98bab03faadb97b34396831e3780aea1"]

  validation {
    condition     = length(var.thumbprint_list) > 0 && alltrue([for t in var.thumbprint_list : length(t) == 40])
    error_message = "thumbprint_list must contain at least one SHA-1 hash (40 characters each)."
  }
}
