variable "region" {
  description = "AWS region to use for the provider."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = trim(var.region) != ""
    error_message = "Region must be a non-empty string."
  }
}

variable "name" {
  description = "Name of the IAM Policy. If null or empty, name_prefix will be used."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || can(regex("^[\\w+=,.@-]{1,128}$", var.name))
    error_message = "If provided, name must match AWS IAM policy name pattern [\\w+=,.@-] and be 1-128 chars."
  }
}

variable "name_prefix" {
  description = "Prefix used to generate a unique IAM Policy name when name is not provided."
  type        = string
  default     = "tf-iam-policy-"

  validation {
    condition     = trim(var.name_prefix) != ""
    error_message = "name_prefix must be a non-empty string."
  }
}

variable "path" {
  description = "Path for the IAM Policy. Must start and end with '/'."
  type        = string
  default     = "/"

  validation {
    condition     = startswith(var.path, "/") && endswith(var.path, "/")
    error_message = "Path must start and end with '/'. Examples: '/', '/service/', '/division/subdivision/'."
  }
}

variable "description" {
  description = "Description of the IAM Policy."
  type        = string
  default     = "Managed by Terraform"
}

variable "tags" {
  description = "A map of tags to assign to the IAM Policy."
  type        = map(string)
  default     = {}
}

variable "policy_json" {
  description = "Raw JSON string for the IAM Policy document. If provided, overrides 'statements'."
  type        = string
  default     = null

  validation {
    condition     = var.policy_json == null || can(jsondecode(var.policy_json))
    error_message = "policy_json must be valid JSON when provided."
  }
}

variable "statements" {
  description = "List of statements to build the IAM Policy document when policy_json is not provided."
  type = list(object({
    sid       = optional(string)
    effect    = string
    actions   = list(string)
    resources = list(string)
    conditions = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })))
  }))
  default = null

  validation {
    condition = var.statements == null || alltrue([
      for s in var.statements :
      (
        (upper(s.effect) == "ALLOW" || upper(s.effect) == "DENY") &&
        length(s.actions) > 0 &&
        length(s.resources) > 0
      )
    ])
    error_message = "Each statement must have effect of Allow or Deny, and non-empty actions and resources."
  }
}
