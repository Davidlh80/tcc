variable "region" {
  description = "AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d+$", var.region))
    error_message = "Region must match the pattern like us-east-1."
  }
}

variable "vpc_id" {
  description = "The ID of the VPC where the Security Group will be created."
  type        = string
  validation {
    condition     = can(regex("^vpc-([0-9a-f]{8}|[0-9a-f]{17})$", var.vpc_id))
    error_message = "vpc_id must look like vpc-xxxxxxxx or vpc-xxxxxxxxxxxxxxxxx."
  }
}

variable "name" {
  description = "Name of the Security Group."
  type        = string
  default     = "secure-sg"
  validation {
    condition     = can(regex("^[A-Za-z0-9-_\\.]{1,128}$", var.name))
    error_message = "Name may include letters, numbers, dashes, underscores and dots, up to 128 chars."
  }
}

variable "description" {
  description = "Description of the Security Group."
  type        = string
  default     = "Security Group managed by Terraform"
  validation {
    condition     = length(var.description) > 0 && length(var.description) <= 255
    error_message = "Description must be between 1 and 255 characters."
  }
}

variable "ingress_rules" {
  description = "List of ingress rules to apply to the Security Group."
  type = list(object({
    description       = string
    protocol          = string         # e.g., tcp, udp, icmp, -1
    from_port         = number
    to_port           = number
    cidr_blocks       = list(string)   # e.g., ["10.0.0.0/16"]
    ipv6_cidr_blocks  = list(string)   # e.g., ["::/0"]
    prefix_list_ids   = list(string)   # e.g., ["pl-12345678"]
  }))
  default = []
  validation {
    condition     = alltrue([for r in var.ingress_rules : r.from_port <= r.to_port])
    error_message = "Ingress rules: from_port must be <= to_port."
  }
}

variable "egress_rules" {
  description = "List of egress rules to apply to the Security Group. If empty, AWS default allow-all may apply."
  type = list(object({
    description       = string
    protocol          = string
    from_port         = number
    to_port           = number
    cidr_blocks       = list(string)
    ipv6_cidr_blocks  = list(string)
    prefix_list_ids   = list(string)
  }))
  default = [
    {
      description      = "Allow all outbound IPv4"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
    }
  ]
  validation {
    condition     = alltrue([for r in var.egress_rules : r.from_port <= r.to_port])
    error_message = "Egress rules: from_port must be <= to_port."
  }
}

variable "tags" {
  description = "Additional tags to apply to the Security Group."
  type        = map(string)
  default     = {}
}
