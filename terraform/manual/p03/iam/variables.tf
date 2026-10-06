variable "aws_region" {
  description = "AWS region where resources will be managed."
  type        = string
}

variable "policy_name" {
  description = "Name of the IAM policy."
  type        = string
}

variable "role_name" {
  description = "Name of the IAM role."
  type        = string
}

variable "environment" {
  description = "Environment associated with the IAM resources."
  type        = string
}

variable "trusted_principal_arn" {
  description = "ARN of the principal allowed to assume the IAM role."
  type        = string
  nullable    = false

  validation {
    condition = can(regex(
      "^arn:[a-z0-9-]+:iam::[0-9]{12}:(root|(role|user)/[A-Za-z0-9+=,.@_/-]+)$",
      var.trusted_principal_arn
    ))

    error_message = "trusted_principal_arn must be an IAM role, user or account root ARN without wildcards."
  }
}

variable "allowed_actions" {
  description = "IAM actions allowed by the policy."
  type        = list(string)
  nullable    = false

  validation {
    condition = (
      length(var.allowed_actions) > 0 &&
      alltrue([
        for action in var.allowed_actions :
        can(regex("^[A-Za-z0-9-]+:[A-Za-z][A-Za-z0-9]*$", action))
      ])
    )

    error_message = "allowed_actions must contain explicit service:Action names without wildcards."
  }
}

variable "allowed_resources" {
  description = "AWS resources on which the allowed actions can be performed."
  type        = list(string)
  nullable    = false

  validation {
    condition = (
      length(var.allowed_resources) > 0 &&
      alltrue([
        for resource in var.allowed_resources :
        can(regex("^arn:[a-z0-9-]+:[a-z0-9-]+:[a-z0-9-]*:([0-9]{12})?:[^*?[:space:]/]+(/[^[:space:]]*)?$", resource))
      ])
    )

    error_message = "allowed_resources must contain scoped ARNs; wildcards are allowed only in paths after '/', never in the resource or bucket name."
  }
}

variable "tags" {
  description = "Additional tags applied to supported IAM resources."
  type        = map(string)
  default     = {}
}
