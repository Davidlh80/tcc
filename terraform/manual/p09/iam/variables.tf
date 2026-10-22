variable "region" {
  type        = string
  description = "Region to allocate the created resource"
  default     = "us-east-1"
}

variable "policy_name" {
  type        = string
  description = "Policy name"
}

variable "role_name" {
  type        = string
  description = "Role name"
}

variable "owner" {
  type        = string
  description = "E-mail of the owner of the resource"
}

variable "environment" {
  type        = string
  description = "Environment (dev, hml or prd)"

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment must be dev, hml or prd."
  }
}

variable "trusted_service" {
  description = "AWS service allowed to assume the role (e.g. lambda.amazonaws.com)"
  type        = string
}

variable "allowed_actions" {
  description = "Actions allowed by the policy"
  type        = list(string)
}

variable "allowed_resources" {
  description = "Resources ARNs the actions apply to"
  type        = list(string)
}
