variable "aws_region" {
  description = "AWS region used by the provider for syntax validation and deployment."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Name of the IAM role."
  type        = string
  default     = "app-role"

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,64}$", var.role_name))
    error_message = "role_name must be 1-64 characters and use only letters, numbers, and the characters + = , . @ -."
  }
}

variable "role_description" {
  description = "Description of the IAM role."
  type        = string
  default     = "Role managed by Terraform with least-privilege permissions."
}

variable "policy_name" {
  description = "Name of the IAM policy attached to the role."
  type        = string
  default     = "app-policy"

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,128}$", var.policy_name))
    error_message = "policy_name must be 1-128 characters and use only letters, numbers, and the characters + = , . @ -."
  }
}

variable "policy_description" {
  description = "Description of the IAM policy."
  type        = string
  default     = "Least-privilege permissions policy managed by Terraform."
}

variable "path" {
  description = "Path applied to both the IAM role and the IAM policy."
  type        = string
  default     = "/"
}

variable "max_session_duration" {
  description = "Maximum session duration (in seconds) for the role. Must be between 3600 (1h) and 43200 (12h)."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration must be between 3600 and 43200 seconds."
  }
}

variable "permissions_boundary_arn" {
  description = "Optional IAM permissions boundary ARN to attach to the role. Null disables it."
  type        = string
  default     = null
}

variable "trusted_service_principals" {
  description = "AWS service principals (e.g. ec2.amazonaws.com) allowed to assume the role. Empty list disables this trust statement."
  type        = list(string)
  default     = ["ec2.amazonaws.com"]
}

variable "trusted_account_arns" {
  description = "IAM principal ARNs (accounts, roles, or users) allowed to assume the role for cross-account access. Empty list disables cross-account trust."
  type        = list(string)
  default     = []
}

variable "external_id" {
  description = "Optional sts:ExternalId condition applied to cross-account assume-role trust statements. Recommended when trusted_account_arns is non-empty."
  type        = string
  default     = null
}

variable "bucket_name" {
  description = "Name (not ARN) of the single S3 bucket the role is granted least-privilege read access to."
  type        = string
  default     = "example-app-data-bucket"
}

variable "tags" {
  description = "Additional tags applied to the IAM role and IAM policy."
  type        = map(string)
  default     = {}
}
