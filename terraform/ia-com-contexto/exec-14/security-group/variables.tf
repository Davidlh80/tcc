variable "region" {
  description = "AWS region where the Security Group will be created."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "Region must match the pattern like us-east-1, eu-west-1, etc."
  }
}

variable "environment" {
  description = "Deployment environment."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment must be one of: dev, hml, prd."
  }
}

variable "system" {
  description = "System name (lowercase, numbers and hyphens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 1
    error_message = "system must contain only lowercase letters, numbers and hyphens, length > 1."
  }
}

variable "security_group_name" {
  description = "Full Security Group name, following <environment>-<system>-sg-<purpose>."
  type        = string

  validation {
    condition     = can(regex("^${var.environment}-${var.system}-sg-[a-z0-9-]+$", var.security_group_name))
    error_message = "security_group_name must follow the pattern <environment>-<system>-sg-<purpose> and match the provided environment and system."
  }
}

variable "vpc_id" {
  description = "VPC ID where the Security Group will be created."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-z]+$", var.vpc_id))
    error_message = "vpc_id must look like vpc-xxxxxxxx."
  }
}

variable "security_group_description" {
  description = "Description for the Security Group resource."
  type        = string

  validation {
    condition     = length(trim(var.security_group_description)) >= 10
    error_message = "security_group_description must be at least 10 characters."
  }
}

variable "security_group_ingress_rules" {
  description = "List of ingress rules."
  type = list(object({
    description       = string
    protocol          = string
    from_port         = number
    to_port           = number
    cidr_blocks       = optional(list(string), [])
    ipv6_cidr_blocks  = optional(list(string), [])
    security_groups   = optional(list(string), [])
    self              = optional(bool, false)
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.security_group_ingress_rules : length(trim(r.description)) > 0])
    error_message = "Each ingress rule must include a non-empty description."
  }

  validation {
    condition = alltrue([
      for r in var.security_group_ingress_rules :
      (contains(coalesce(r.cidr_blocks, []), "0.0.0.0/0") || contains(coalesce(r.ipv6_cidr_blocks, []), "::/0"))
      ? (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      : true
    ])
    error_message = "Ingress cannot expose 0.0.0.0/0 or ::/0 except exactly tcp/443."
  }

  validation {
    condition     = alltrue([for r in var.security_group_ingress_rules : r.to_port >= r.from_port])
    error_message = "In each ingress rule, to_port must be greater than or equal to from_port."
  }
}

variable "security_group_egress_rules" {
  description = "List of egress rules. Default empty (no egress allowed)."
  type = list(object({
    description       = string
    protocol          = string
    from_port         = number
    to_port           = number
    cidr_blocks       = optional(list(string), [])
    ipv6_cidr_blocks  = optional(list(string), [])
    security_groups   = optional(list(string), [])
    self              = optional(bool, false)
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.security_group_egress_rules : length(trim(r.description)) > 0])
    error_message = "Each egress rule must include a non-empty description."
  }

  validation {
    condition = alltrue([
      for r in var.security_group_egress_rules :
      (contains(coalesce(r.cidr_blocks, []), "0.0.0.0/0") || contains(coalesce(r.ipv6_cidr_blocks, []), "::/0"))
      ? (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      : true
    ])
    error_message = "Egress cannot allow 0.0.0.0/0 or ::/0 except exactly tcp/443."
  }

  validation {
    condition     = alltrue([for r in var.security_group_egress_rules : r.to_port >= r.from_port])
    error_message = "In each egress rule, to_port must be greater than or equal to from_port."
  }
}

variable "additional_tags" {
  description = "Additional tags to merge with mandatory tags."
  type        = map(string)
  default     = {}
}
