variable "region" {
  description = "AWS region to deploy resources."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d+$", var.region))
    error_message = "The region must match the pattern like us-east-1."
  }
}

variable "vpc_id" {
  description = "The ID of the VPC where the Security Group will be created."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]+$", var.vpc_id))
    error_message = "vpc_id must be a valid VPC ID (e.g., vpc-abc123def4567890)."
  }
}

variable "sg_name" {
  description = "Name of the Security Group."
  type        = string
  default     = "secure-sg"

  validation {
    condition     = length(trim(var.sg_name)) > 0 && length(var.sg_name) <= 255
    error_message = "sg_name must be non-empty and up to 255 characters."
  }
}

variable "sg_description" {
  description = "Description of the Security Group."
  type        = string
  default     = "Security Group managed by Terraform"
}

variable "revoke_rules_on_delete" {
  description = "Revoke associated security group rules before deleting the security group."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to apply to the Security Group."
  type        = map(string)
  default     = {}
}

variable "ingress_rules" {
  description = <<EOT
List of ingress rule objects. For each rule, exactly one source must be specified among: cidr_blocks, ipv6_cidr_blocks, prefix_list_ids, source_security_group_id.
Protocol '-1' means all protocols and requires from_port = 0 and to_port = 0.

Example:
[
  {
    description               = "Allow HTTPS from anywhere"
    protocol                  = "tcp"
    from_port                 = 443
    to_port                   = 443
    cidr_blocks               = ["0.0.0.0/0"]
    ipv6_cidr_blocks          = []
    prefix_list_ids           = []
    source_security_group_id  = ""
  }
]
EOT
  type = list(object({
    description              = string
    protocol                 = string
    from_port                = number
    to_port                  = number
    cidr_blocks              = list(string)
    ipv6_cidr_blocks         = list(string)
    prefix_list_ids          = list(string)
    source_security_group_id = string
  }))
  default = []

  validation {
    condition = length([
      for r in var.ingress_rules : r
      if (
        (
          (length(r.cidr_blocks) > 0 ? 1 : 0) +
          (length(r.ipv6_cidr_blocks) > 0 ? 1 : 0) +
          (length(r.prefix_list_ids) > 0 ? 1 : 0) +
          (length(r.source_security_group_id) > 0 ? 1 : 0)
        ) == 1
        &&
        (r.protocol == "-1" ? (r.from_port == 0 && r.to_port == 0) : (r.from_port >= 0 && r.to_port >= r.from_port))
      )
    ]) == length(var.ingress_rules)
    error_message = "Each ingress rule must specify exactly one of: cidr_blocks, ipv6_cidr_blocks, prefix_list_ids, source_security_group_id. If protocol is '-1', from_port and to_port must both be 0; otherwise from_port >= 0 and to_port >= from_port."
  }
}

variable "egress_rules" {
  description = <<EOT
List of egress rule objects. For each rule, exactly one destination must be specified among: cidr_blocks, ipv6_cidr_blocks, prefix_list_ids, destination_security_group_id.
Protocol '-1' means all protocols and requires from_port = 0 and to_port = 0.

Example:
[
  {
    description                     = "Allow HTTPS outbound"
    protocol                        = "tcp"
    from_port                       = 443
    to_port                         = 443
    cidr_blocks                     = ["0.0.0.0/0"]
    ipv6_cidr_blocks                = []
    prefix_list_ids                 = []
    destination_security_group_id   = ""
  }
]
EOT
  type = list(object({
    description                    = string
    protocol                       = string
    from_port                      = number
    to_port                        = number
    cidr_blocks                    = list(string)
    ipv6_cidr_blocks               = list(string)
    prefix_list_ids                = list(string)
    destination_security_group_id  = string
  }))
  default = []

  validation {
    condition = length([
      for r in var.egress_rules : r
      if (
        (
          (length(r.cidr_blocks) > 0 ? 1 : 0) +
          (length(r.ipv6_cidr_blocks) > 0 ? 1 : 0) +
          (length(r.prefix_list_ids) > 0 ? 1 : 0) +
          (length(r.destination_security_group_id) > 0 ? 1 : 0)
        ) == 1
        &&
        (r.protocol == "-1" ? (r.from_port == 0 && r.to_port == 0) : (r.from_port >= 0 && r.to_port >= r.from_port))
      )
    ]) == length(var.egress_rules)
    error_message = "Each egress rule must specify exactly one of: cidr_blocks, ipv6_cidr_blocks, prefix_list_ids, destination_security_group_id. If protocol is '-1', from_port and to_port must both be 0; otherwise from_port >= 0 and to_port >= from_port."
  }
}
