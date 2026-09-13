variable "aws_region" {
  type        = string
  description = "AWS region used by the provider."
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "aws_region must be a valid AWS region identifier, e.g. us-east-1."
  }
}

variable "policy_name" {
  type        = string
  description = "Name of the IAM policy. Must be unique within the AWS account."

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128 && can(regex("^[\\w+=,.@-]+$", var.policy_name))
    error_message = "policy_name must be 1-128 characters long and contain only alphanumeric characters and the symbols + = , . @ - _"
  }
}

variable "policy_description" {
  type        = string
  description = "Description of the IAM policy."
  default     = "Managed by Terraform."

  validation {
    condition     = length(var.policy_description) <= 1000
    error_message = "policy_description must be at most 1000 characters long."
  }
}

variable "policy_path" {
  type        = string
  description = "Path under which the IAM policy is created."
  default     = "/"

  validation {
    condition     = can(regex("^/([\\w+=,.@-]+/)*$", var.policy_path))
    error_message = "policy_path must begin and end with a slash, e.g. / or /app/service/."
  }
}

variable "statements" {
  description = "List of IAM policy statements. Prefer explicit actions and resource ARNs over wildcards to keep least privilege."
  type = list(object({
    sid       = optional(string)
    effect    = optional(string, "Allow")
    actions   = list(string)
    resources = list(string)
  }))

  default = [
    {
      sid       = "AllowS3ReadOnlyExampleBucket"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]
    }
  ]

  validation {
    condition     = length(var.statements) > 0
    error_message = "statements must contain at least one policy statement."
  }

  validation {
    condition     = alltrue([for s in var.statements : contains(["Allow", "Deny"], s.effect)])
    error_message = "Each statement's effect must be either \"Allow\" or \"Deny\"."
  }

  validation {
    condition     = alltrue([for s in var.statements : length(s.actions) > 0])
    error_message = "Each statement must declare at least one action."
  }

  validation {
    condition     = alltrue([for s in var.statements : length(s.resources) > 0])
    error_message = "Each statement must declare at least one resource. Avoid using \"*\" unless strictly necessary."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the IAM policy."
  default     = {}
}
