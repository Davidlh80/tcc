variable "aws_region" {
  description = "AWS region to use for the provider."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}(-gov)?-[a-z]+-\\d+$", var.aws_region))
    error_message = "The aws_region must match the pattern like us-east-1 or us-gov-west-1."
  }
}

variable "policy_name" {
  description = "Name of the IAM Policy."
  type        = string
  default     = "iam-secure-transport-policy"

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]{1,128}$", var.policy_name))
    error_message = "policy_name must be 1-128 characters and contain only A-Za-z0-9+=,.@_-"
  }
}

variable "policy_description" {
  description = "Description of the IAM Policy."
  type        = string
  default     = "IAM policy that denies requests over insecure transport (non-TLS). You can append additional allow/deny statements via allow_statements."
}

variable "policy_path" {
  description = "Path for the IAM Policy."
  type        = string
  default     = "/"

  validation {
    condition     = startswith(var.policy_path, "/") && endswith(var.policy_path, "/")
    error_message = "policy_path must start and end with '/'."
  }
}

variable "allow_statements" {
  description = "Additional policy statements to include (e.g., least-privilege allows)."
  type = list(object({
    actions   = list(string)
    resources = list(string)
    effect    = optional(string) # Allow or Deny
    conditions = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })))
  }))
  default = []

  validation {
    condition = alltrue([
      for s in var.allow_statements :
      length(s.actions) > 0 &&
      length(s.resources) > 0 &&
      alltrue([for a in s.actions : length(trim(a)) > 0]) &&
      alltrue([for r in s.resources : length(trim(r)) > 0]) &&
      (
        s.effect == null ||
        contains(["Allow", "Deny", "ALLOW", "DENY", "allow", "deny"], s.effect)
      )
    ])
    error_message = "Each allow_statement must have non-empty actions/resources and, if provided, effect must be Allow or Deny."
  }
}

variable "tags" {
  description = "Tags to apply to the IAM Policy."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags :
      length(trim(k)) > 0 && length(k) <= 128 && length(v) <= 256
    ])
    error_message = "Tag keys must be non-empty (<=128 chars) and values must be <=256 chars."
  }
}
