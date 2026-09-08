variable "region" {
  description = "AWS region to use for the provider."
  type        = string

  validation {
    condition     = length(trim(var.region)) > 0
    error_message = "The region must be a non-empty string (e.g., us-east-1)."
  }
}

variable "policy_name" {
  description = "Name of the IAM Policy. Must be unique within the account."
  type        = string
  default     = "tf-managed-iam-policy"

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]+$", var.policy_name)) && length(var.policy_name) <= 128
    error_message = "policy_name must be <= 128 chars and contain only letters, numbers, and +=,.@_- characters."
  }
}

variable "policy_description" {
  description = "Description for the IAM Policy."
  type        = string
  default     = "Managed by Terraform"
}

variable "policy_path" {
  description = "Path under which to create the IAM Policy."
  type        = string
  default     = "/"

  validation {
    condition     = startswith(var.policy_path, "/") && endswith(var.policy_path, "/")
    error_message = "policy_path must start and end with '/'. Example: '/service-role/'."
  }
}

variable "environment" {
  description = "Environment tag to apply to the IAM Policy."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod", "test", "sandbox"], var.environment)
    error_message = "environment must be one of: dev, staging, prod, test, sandbox."
  }
}

variable "tags" {
  description = "Additional tags to apply to the IAM Policy."
  type        = map(string)
  default     = {}
}

variable "statements" {
  description = "List of statements to include in the IAM policy document."
  type = list(object({
    sid       = string
    effect    = string
    actions   = list(string)
    resources = list(string)
    conditions = list(object({
      test     = string
      variable = string
      values   = list(string)
    }))
  }))

  default = [
    {
      sid       = "DefaultListBuckets"
      effect    = "Allow"
      actions   = ["s3:ListAllMyBuckets", "s3:GetBucketLocation"]
      resources = ["*"]
      conditions = []
    }
  ]

  validation {
    condition     = length(var.statements) > 0
    error_message = "At least one statement must be provided."
  }
}
