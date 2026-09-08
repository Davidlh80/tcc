variable "region" {
  description = "AWS region to deploy resources."
  type        = string
  default     = "us-east-1"
  validation {
    condition     = length(var.region) > 0
    error_message = "Region must be a non-empty string."
  }
}

variable "vpc_id" {
  description = "ID of the VPC where the Security Group will be created."
  type        = string
  validation {
    condition     = can(regex("^vpc-([0-9a-f]{8}|[0-9a-f]{17})$", var.vpc_id))
    error_message = "vpc_id must match pattern vpc-xxxxxxxx or vpc-xxxxxxxxxxxxxxxxx with lowercase hex characters."
  }
}

variable "name" {
  description = "Name of the Security Group."
  type        = string
  default     = "sg-managed"
  validation {
    condition     = can(regex("^[A-Za-z0-9-_]{1,128}$", var.name))
    error_message = "Name must be 1-128 characters and only contain letters, numbers, hyphens, or underscores."
  }
}

variable "description" {
  description = "Description of the Security Group."
  type        = string
  default     = "Security group managed by Terraform"
  validation {
    condition     = length(var.description) > 0 && length(var.description) <= 255
    error_message = "Description must be between 1 and 255 characters."
  }
}

variable "revoke_rules_on_delete" {
  description = "When destroying, revoke security group rules before deleting the security group."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to apply to the Security Group."
  type        = map(string)
  default     = {}
}

variable "ingress_rules" {
  description = "List of ingress rules to add to the Security Group."
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    security_groups  = list(string) # Source security group IDs
    self             = bool
  }))
  default = []
  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      r.from_port >= 0 && r.from_port <= 65535 &&
      r.to_port >= 0 && r.to_port <= 65535 &&
      r.from_port <= r.to_port
    ])
    error_message = "Each ingress rule must have valid ports: 0-65535 and from_port <= to_port."
  }
  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      contains(["tcp", "udp", "icmp", "icmpv6", "-1"], lower(r.protocol))
    ])
    error_message = "Ingress rule protocol must be one of: tcp, udp, icmp, icmpv6, -1."
  }
  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.security_groups) + (r.self ? 1 : 0)) > 0
    ])
    error_message = "Each ingress rule must define at least one source via cidr_blocks, ipv6_cidr_blocks, security_groups, or self=true."
  }
}

variable "egress_rules" {
  description = "List of egress rules to add to the Security Group."
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    security_groups  = list(string) # Destination security group IDs
    self             = bool
  }))
  default = [
    {
      description      = "Allow all egress (IPv4/IPv6)"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = []
      self             = false
    }
  ]
  validation {
    condition = alltrue([
      for r in var.egress_rules :
      r.from_port >= 0 && r.from_port <= 65535 &&
      r.to_port >= 0 && r.to_port <= 65535 &&
      r.from_port <= r.to_port
    ])
    error_message = "Each egress rule must have valid ports: 0-65535 and from_port <= to_port."
  }
  validation {
    condition = alltrue([
      for r in var.egress_rules :
      contains(["tcp", "udp", "icmp", "icmpv6", "-1"], lower(r.protocol))
    ])
    error_message = "Egress rule protocol must be one of: tcp, udp, icmp, icmpv6, -1."
  }
  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.security_groups) + (r.self ? 1 : 0)) > 0
    ])
    error_message = "Each egress rule must define at least one destination via cidr_blocks, ipv6_cidr_blocks, security_groups, or self=true."
  }
}
