variable "region" {
  description = "AWS region to deploy resources into."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "Region must look like 'us-east-1', 'eu-west-1', etc."
  }
}

variable "name" {
  description = "Name of the Security Group."
  type        = string
  default     = "sg-app"

  validation {
    condition     = can(regex("^[A-Za-z0-9-_]+$", var.name)) && length(var.name) <= 255
    error_message = "Name must contain only letters, numbers, hyphens or underscores and be at most 255 characters."
  }
}

variable "description" {
  description = "Description of the Security Group."
  type        = string
  default     = "Security Group managed by Terraform"
}

variable "vpc_id" {
  description = "ID of the VPC where the Security Group will be created."
  type        = string

  validation {
    condition     = length(var.vpc_id) > 4 && substr(var.vpc_id, 0, 4) == "vpc-"
    error_message = "vpc_id must be a valid VPC ID (e.g., vpc-xxxxxxxx)."
  }
}

variable "allow_ssh_from_cidrs" {
  description = "List of CIDR blocks allowed to access TCP/22 (SSH)."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for c in var.allow_ssh_from_cidrs : can(cidrhost(c, 0))])
    error_message = "allow_ssh_from_cidrs must contain valid IPv4 or IPv6 CIDR blocks."
  }
}

variable "allow_http_from_cidrs" {
  description = "List of CIDR blocks allowed to access TCP/80 (HTTP)."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for c in var.allow_http_from_cidrs : can(cidrhost(c, 0))])
    error_message = "allow_http_from_cidrs must contain valid IPv4 or IPv6 CIDR blocks."
  }
}

variable "allow_https_from_cidrs" {
  description = "List of CIDR blocks allowed to access TCP/443 (HTTPS)."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for c in var.allow_https_from_cidrs : can(cidrhost(c, 0))])
    error_message = "allow_https_from_cidrs must contain valid IPv4 or IPv6 CIDR blocks."
  }
}

variable "additional_ingress_rules" {
  description = "Additional ingress rules. At least one of cidr_blocks, ipv6_cidr_blocks or prefix_list_ids must be set in each rule."
  type = list(object({
    description      = string
    protocol         = string
    from_port        = number
    to_port          = number
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
    prefix_list_ids  = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.additional_ingress_rules :
      (r.from_port >= 0 && r.from_port <= 65535) &&
      (r.to_port >= 0 && r.to_port <= 65535) &&
      (r.to_port >= r.from_port)
    ])
    error_message = "Each additional_ingress_rules item must have from_port/to_port within 0-65535 and to_port >= from_port."
  }

  validation {
    condition = alltrue([
      for r in var.additional_ingress_rules :
      (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.prefix_list_ids)) > 0
    ])
    error_message = "Each additional_ingress_rules item must specify at least one of cidr_blocks, ipv6_cidr_blocks or prefix_list_ids."
  }

  validation {
    condition = alltrue(flatten([
      for r in var.additional_ingress_rules : [
        for c in r.cidr_blocks : can(cidrhost(c, 0))
      ]
    ]))
    error_message = "All IPv4 CIDRs in additional_ingress_rules.cidr_blocks must be valid CIDR blocks."
  }

  validation {
    condition = alltrue(flatten([
      for r in var.additional_ingress_rules : [
        for c in r.ipv6_cidr_blocks : can(cidrhost(c, 0))
      ]
    ]))
    error_message = "All IPv6 CIDRs in additional_ingress_rules.ipv6_cidr_blocks must be valid CIDR blocks."
  }
}

variable "allow_all_egress" {
  description = "If true, create egress rules allowing all protocols to the specified egress CIDRs."
  type        = bool
  default     = false
}

variable "egress_cidr_blocks" {
  description = "IPv4 CIDR blocks for outbound traffic when allow_all_egress is true."
  type        = list(string)
  default     = ["0.0.0.0/0"]

  validation {
    condition     = alltrue([for c in var.egress_cidr_blocks : can(cidrhost(c, 0))])
    error_message = "egress_cidr_blocks must contain valid IPv4 CIDR blocks."
  }
}

variable "egress_ipv6_cidr_blocks" {
  description = "IPv6 CIDR blocks for outbound traffic when allow_all_egress is true."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for c in var.egress_ipv6_cidr_blocks : can(cidrhost(c, 0))])
    error_message = "egress_ipv6_cidr_blocks must contain valid IPv6 CIDR blocks."
  }
}

variable "tags" {
  description = "Additional tags to apply to the Security Group."
  type        = map(string)
  default     = {}
}
