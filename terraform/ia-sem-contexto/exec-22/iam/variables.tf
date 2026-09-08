variable "aws_region" {
  description = "AWS region to use for the provider."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(var.aws_region) > 0 && can(regex("^[a-z]{2}(-gov)?-[a-z]+-\\d$", var.aws_region))
    error_message = "Provide a valid AWS region identifier (e.g., us-east-1, eu-west-1, us-gov-west-1)."
  }
}

variable "name" {
  description = "Explicit name for the IAM Policy. If empty, name_prefix will be used."
  type        = string
  default     = ""

  validation {
    condition     = length(var.name) == 0 || (length(var.name) >= 1 && length(var.name) <= 128)
    error_message = "If provided, name must be between 1 and 128 characters."
  }
}

variable "name_prefix" {
  description = "Prefix used to generate a unique name when 'name' is empty."
  type        = string
  default     = "tf-iam-policy-"

  validation {
    condition     = length(var.name_prefix) >= 1 && length(var.name_prefix) <= 128
    error_message = "name_prefix must be between 1 and 128 characters."
  }
}

variable "description" {
  description = "Description for the IAM Policy."
  type        = string
  default     = "Managed IAM policy created by Terraform."

  validation {
    condition     = length(var.description) <= 1000
    error_message = "Description must be at most 1000 characters."
  }
}

variable "path" {
  description = "Path for the IAM Policy (must start and end with '/')."
  type        = string
  default     = "/"

  validation {
    condition     = startswith(var.path, "/") && endswith(var.path, "/")
    error_message = "path must start and end with '/' (e.g., '/', '/application/')."
  }
}

variable "tags" {
  description = "Map of tags to assign to the IAM Policy."
  type        = map(string)
  default     = {}
}

variable "statements" {
  description = "List of policy statements to include in the IAM Policy."
  type = list(object({
    sid           = optional(string)
    effect        = optional(string, "Allow") # 'Allow' or 'Deny'
    actions       = optional(list(string), [])
    not_actions   = optional(list(string), [])
    resources     = optional(list(string), [])
    not_resources = optional(list(string), [])
    conditions = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })), [])
  }))
  default = [
    {
      sid       = "ReadOnlyCommon"
      effect    = "Allow"
      actions   = [
        "ec2:Describe*",
        "rds:Describe*",
        "s3:ListAllMyBuckets",
        "s3:GetBucketLocation",
        "cloudwatch:Get*",
        "cloudwatch:List*",
        "logs:Describe*",
        "logs:Get*",
        "logs:List*",
        "iam:Get*",
        "iam:List*"
      ]
      resources = ["*"]
    }
  ]

  validation {
    condition     = length(var.statements) > 0
    error_message = "Provide at least one policy statement."
  }
}
