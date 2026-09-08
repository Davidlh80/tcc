variable "aws_region" {
  description = "AWS region to use for the provider."
  type        = string
  default     = "us-east-1"
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "The aws_region must be in the form e.g. us-east-1."
  }
}

variable "policy_name" {
  description = "Name of the IAM policy."
  type        = string
  default     = "example-iam-policy"
  validation {
    condition     = length(var.policy_name) >= 1 && length(var.policy_name) <= 128 && can(regex("^[A-Za-z0-9+=,.@_-]+$", var.policy_name))
    error_message = "policy_name must be 1-128 characters using A-Za-z0-9+=,.@_-."
  }
}

variable "policy_description" {
  description = "Description of the IAM policy."
  type        = string
  default     = "Managed by Terraform - example IAM policy."
  validation {
    condition     = length(var.policy_description) <= 1000
    error_message = "policy_description must be 1000 characters or fewer."
  }
}

variable "policy_path" {
  description = "Path for the IAM policy. Must start and end with a slash."
  type        = string
  default     = "/"
  validation {
    condition     = can(regex("^/.*/$", var.policy_path))
    error_message = "policy_path must start and end with '/'. Example: /service/ or /"
  }
}

variable "policy_statements" {
  description = "List of policy statements composing the policy document."
  type = list(object({
    sid           = optional(string)
    effect        = string
    actions       = optional(list(string))
    not_actions   = optional(list(string))
    resources     = optional(list(string))
    not_resources = optional(list(string))
    conditions    = optional(map(map(list(string))))
  }))
  default = [
    {
      sid      = "ReadAccountInfo"
      effect   = "Allow"
      actions  = ["sts:GetCallerIdentity", "iam:ListAccountAliases", "iam:GetAccountPasswordPolicy"]
      resources = ["*"]
    }
  ]
  validation {
    condition     = length(var.policy_statements) >= 1
    error_message = "At least one statement must be provided."
  }
}

variable "tags" {
  description = "Tags to apply to the IAM policy."
  type        = map(string)
  default     = {}
}

variable "attach_to_roles" {
  description = "List of IAM role names to attach the policy to."
  type        = list(string)
  default     = []
  validation {
    condition     = alltrue([for r in var.attach_to_roles : can(regex("^[A-Za-z0-9+=,.@_-]{1,64}$", r))])
    error_message = "Each role name must be 1-64 characters using A-Za-z0-9+=,.@_-."
  }
}

variable "attach_to_users" {
  description = "List of IAM user names to attach the policy to."
  type        = list(string)
  default     = []
  validation {
    condition     = alltrue([for u in var.attach_to_users : can(regex("^[A-Za-z0-9+=,.@_-]{1,64}$", u))])
    error_message = "Each user name must be 1-64 characters using A-Za-z0-9+=,.@_-."
  }
}

variable "attach_to_groups" {
  description = "List of IAM group names to attach the policy to."
  type        = list(string)
  default     = []
  validation {
    condition     = alltrue([for g in var.attach_to_groups : can(regex("^[A-Za-z0-9+=,.@_-]{1,128}$", g))])
    error_message = "Each group name must be 1-128 characters using A-Za-z0-9+=,.@_-."
  }
}
