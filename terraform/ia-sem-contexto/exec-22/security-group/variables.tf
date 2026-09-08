variable "region" {
  description = "AWS region to deploy resources."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "Provide a valid AWS region identifier (e.g., us-east-1)."
  }
}

variable "vpc_id" {
  description = "The ID of the VPC where the Security Group will be created."
  type        = string

  validation {
    condition     = can(regex("^vpc-([0-9a-f]{8}|[0-9a-f]{17})$", var.vpc_id))
    error_message = "vpc_id must look like vpc-xxxxxxxx or vpc-xxxxxxxxxxxxxxxxx (hex)."
  }
}

variable "name" {
  description = "Name of the Security Group."
  type        = string
  default     = "sg-app"

  validation {
    condition     = length(trim(var.name)) > 0 && length(var.name) <= 255
    error_message = "name must be between 1 and 255 characters."
  }
}

variable "description" {
  description = "Description of the Security Group."
  type        = string
  default     = "Security Group managed by Terraform"

  validation {
    condition     = length(trim(var.description)) > 0 && length(var.description) <= 255
    error_message = "description must be between 1 and 255 characters."
  }
}

variable "revoke_rules_on_delete" {
  description = "Revoke security group rules on deletion to avoid dangling rules."
  type        = bool
  default     = true
}

variable "enable_default_egress" {
  description = "When true and no egress_rules are provided, allow all outbound traffic (IPv4 and IPv6)."
  type        = bool
  default     = true
}

variable "ingress_rules" {
  description = "List of ingress rules."
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    prefix_list_ids  = list(string)
    security_groups  = list(string)
    self             = bool
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      r.from_port >= 0 && r.to_port <= 65535 && r.to_port >= r.from_port
    ])
    error_message = "Each ingress rule must have 0 <= from_port <= to_port <= 65535."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      length(concat(r.cidr_blocks, r.ipv6_cidr_blocks, r.prefix_list_ids, r.security_groups)) > 0 || r.self
    ])
    error_message = "Each ingress rule must specify at least one source (cidr_blocks, ipv6_cidr_blocks, prefix_list_ids, security_groups or self=true)."
  }
}

variable "egress_rules" {
  description = "List of egress rules. If empty and enable_default_egress is true, a default allow-all egress will be created."
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    prefix_list_ids  = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      r.from_port >= 0 && r.to_port <= 65535 && r.to_port >= r.from_port
    ])
    error_message = "Each egress rule must have 0 <= from_port <= to_port <= 65535."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      length(concat(r.cidr_blocks, r.ipv6_cidr_blocks, r.prefix_list_ids)) > 0
    ])
    error_message = "Each egress rule must specify at least one destination (cidr_blocks, ipv6_cidr_blocks or prefix_list_ids)."
  }
}

variable "tags" {
  description = "Additional tags to apply to the Security Group."
  type        = map(string)
  default     = {}
}
