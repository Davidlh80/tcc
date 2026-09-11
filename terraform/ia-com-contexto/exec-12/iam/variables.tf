variable "region" {
  description = "AWS region where the IAM Policy will be managed."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "region must be a valid AWS region string (e.g., us-east-1, sa-east-1)."
  }
}

variable "environment" {
  description = "Deployment environment identifier."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment must be one of: dev, hml, prd."
  }
}

variable "system" {
  description = "System identifier (lowercase, numbers and hyphens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "policy_name" {
  description = "Purpose of the policy (finalidade) used in the naming convention."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name)) && length(var.policy_name) > 0
    error_message = "policy_name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "allowed_actions" {
  description = "List of IAM actions explicitly allowed by the policy."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions must contain at least one action."
  }

  validation {
    condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
    error_message = "It is forbidden to combine Action '*' with Resource '*' in the same statement."
  }
}

variable "allowed_resources" {
  description = "List of resources ARNs (or specific ARNs) explicitly allowed by the policy."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources must contain at least one resource (use specific ARNs whenever possible)."
  }

  validation {
    condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
    error_message = "It is forbidden to combine Action '*' with Resource '*' in the same statement."
  }
}

variable "policy_path" {
  description = "Path for the IAM Policy."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/.*/?$", var.policy_path))
    error_message = "policy_path must start with '/' and typically end with '/'."
  }
}

variable "description" {
  description = "Optional description for the IAM Policy. If null, a standard description is generated."
  type        = string
  default     = null
}

variable "additional_tags" {
  description = "Additional tags to merge with mandatory organizational tags."
  type        = map(string)
  default     = {}
}
