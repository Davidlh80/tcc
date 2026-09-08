variable "region" {
  description = "AWS region to deploy resources."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^([a-z]{2}(-gov)?-[a-z]+-\\d)$", var.region))
    error_message = "Region must match the pattern like us-east-1, eu-west-1 or us-gov-west-1."
  }
}

variable "vpc_id" {
  description = "The ID of the VPC where the Security Group will be created."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]+$", var.vpc_id))
    error_message = "vpc_id must look like 'vpc-xxxxxxxx'."
  }
}

variable "name" {
  description = "Name of the Security Group."
  type        = string
  default     = "secure-sg"

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]{1,128}$", var.name))
    error_message = "Name must be 1-128 chars and use only letters, numbers, dot, underscore or hyphen."
  }
}

variable "description" {
  description = "Description for the Security Group."
  type        = string
  default     = "Security Group managed by Terraform"
}

variable "revoke_rules_on_delete" {
  description = "Revoke security group rules before deleting the security group."
  type        = bool
  default     = true
}

variable "ingress_rules" {
  description = "List of ingress rules to add to the Security Group."
  type = list(object({
    description        = optional(string, "")
    from_port          = number
    to_port            = number
    protocol           = string
    cidr_blocks        = optional(list(string), [])
    ipv6_cidr_blocks   = optional(list(string), [])
    security_group_ids = optional(list(string), [])
    self               = optional(bool, false)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      r.from_port <= r.to_port
    ])
    error_message = "For each ingress rule, from_port must be less than or equal to to_port."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (r.from_port >= -1 && r.from_port <= 65535) && (r.to_port >= -1 && r.to_port <= 65535)
    ])
    error_message = "Ingress rule ports must be between -1 and 65535."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (r.protocol == "-1") || contains(["tcp", "udp", "icmp", "icmpv6"], lower(r.protocol))
    ])
    error_message = "Ingress rule protocol must be one of: -1 (all), tcp, udp, icmp, icmpv6."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.security_group_ids) + (r.self ? 1 : 0)) > 0
    ])
    error_message = "Each ingress rule must target at least one of: cidr_blocks, ipv6_cidr_blocks, security_group_ids, or self = true."
  }

  validation {
    condition = alltrue([
      for c in flatten([for r in var.ingress_rules : r.cidr_blocks]) :
      can(cidrhost(c, 0))
    ])
    error_message = "All IPv4 CIDRs in ingress_rules.cidr_blocks must be valid CIDR notation."
  }

  validation {
    condition = alltrue([
      for c in flatten([for r in var.ingress_rules : r.ipv6_cidr_blocks]) :
      can(cidrhost(c, 0))
    ])
    error_message = "All IPv6 CIDRs in ingress_rules.ipv6_cidr_blocks must be valid CIDR notation."
  }
}

variable "egress_rules" {
  description = "List of egress rules to add to the Security Group. Defaults to none (deny all egress)."
  type = list(object({
    description        = optional(string, "")
    from_port          = number
    to_port            = number
    protocol           = string
    cidr_blocks        = optional(list(string), [])
    ipv6_cidr_blocks   = optional(list(string), [])
    security_group_ids = optional(list(string), [])
    self               = optional(bool, false)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      r.from_port <= r.to_port
    ])
    error_message = "For each egress rule, from_port must be less than or equal to to_port."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (r.from_port >= -1 && r.from_port <= 65535) && (r.to_port >= -1 && r.to_port <= 65535)
    ])
    error_message = "Egress rule ports must be between -1 and 65535."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (r.protocol == "-1") || contains(["tcp", "udp", "icmp", "icmpv6"], lower(r.protocol))
    ])
    error_message = "Egress rule protocol must be one of: -1 (all), tcp, udp, icmp, icmpv6."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.security_group_ids) + (r.self ? 1 : 0)) > 0
    ])
    error_message = "Each egress rule must target at least one of: cidr_blocks, ipv6_cidr_blocks, security_group_ids, or self = true."
  }

  validation {
    condition = alltrue([
      for c in flatten([for r in var.egress_rules : r.cidr_blocks]) :
      can(cidrhost(c, 0))
    ])
    error_message = "All IPv4 CIDRs in egress_rules.cidr_blocks must be valid CIDR notation."
  }

  validation {
    condition = alltrue([
      for c in flatten([for r in var.egress_rules : r.ipv6_cidr_blocks]) :
      can(cidrhost(c, 0))
    ])
    error_message = "All IPv6 CIDRs in egress_rules.ipv6_cidr_blocks must be valid CIDR notation."
  }
}

variable "tags" {
  description = "Additional tags to apply to the Security Group."
  type        = map(string)
  default     = {}
}
