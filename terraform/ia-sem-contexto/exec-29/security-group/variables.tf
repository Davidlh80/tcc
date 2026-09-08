variable "region" {
  description = "AWS region to use."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d+$", var.region))
    error_message = "Region must match the pattern like us-east-1."
  }
}

variable "vpc_id" {
  description = "The VPC ID where the Security Group will be created."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]+$", var.vpc_id))
    error_message = "vpc_id must look like 'vpc-xxxxxxxx'."
  }
}

variable "name" {
  description = "Security Group name. Limited to letters, numbers, spaces, dashes, underscores, and dots."
  type        = string
  default     = "sg-managed"

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255 && can(regex("^[A-Za-z0-9._\\- ]+$", var.name))
    error_message = "Name must be 1-255 characters and use only letters, numbers, space, dash (-), underscore (_), and dot (.)."
  }
}

variable "description" {
  description = "Security Group description."
  type        = string
  default     = "Managed by Terraform - Security Group"
}

variable "revoke_rules_on_delete" {
  description = "Ensure rules are revoked before SG deletion to avoid dangling dependencies."
  type        = bool
  default     = true
}

variable "ingress_rules" {
  description = <<EOT
List of ingress rules. Each rule object:
- description: string (rule description)
- protocol: string (e.g., 'tcp', 'udp', 'icmp', 'icmpv6', or '-1' for all)
- from_port: number
- to_port: number
- ipv4_cidr_blocks: list(string)
- ipv6_cidr_blocks: list(string)
Example:
[
  {
    description       = "SSH from office"
    protocol          = "tcp"
    from_port         = 22
    to_port           = 22
    ipv4_cidr_blocks  = ["203.0.113.0/24"]
    ipv6_cidr_blocks  = []
  }
]
EOT
  type = list(object({
    description       = string
    protocol          = string
    from_port         = number
    to_port           = number
    ipv4_cidr_blocks  = list(string)
    ipv6_cidr_blocks  = list(string)
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.ingress_rules : r.from_port <= r.to_port])
    error_message = "For all ingress rules, from_port must be <= to_port."
  }

  validation {
    condition     = alltrue([for r in var.ingress_rules : contains(["tcp", "udp", "icmp", "icmpv6", "-1"], lower(r.protocol))])
    error_message = "Ingress rule protocol must be one of: tcp, udp, icmp, icmpv6, -1."
  }
}

variable "egress_rules" {
  description = <<EOT
List of egress rules. Each rule object:
- description: string (rule description)
- protocol: string (e.g., 'tcp', 'udp', 'icmp', 'icmpv6', or '-1' for all)
- from_port: number
- to_port: number
- ipv4_cidr_blocks: list(string)
- ipv6_cidr_blocks: list(string)
Example (allow HTTPS egress):
[
  {
    description       = "HTTPS egress"
    protocol          = "tcp"
    from_port         = 443
    to_port           = 443
    ipv4_cidr_blocks  = ["0.0.0.0/0"]
    ipv6_cidr_blocks  = ["::/0"]
  }
]
EOT
  type = list(object({
    description       = string
    protocol          = string
    from_port         = number
    to_port           = number
    ipv4_cidr_blocks  = list(string)
    ipv6_cidr_blocks  = list(string)
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.egress_rules : r.from_port <= r.to_port])
    error_message = "For all egress rules, from_port must be <= to_port."
  }

  validation {
    condition     = alltrue([for r in var.egress_rules : contains(["tcp", "udp", "icmp", "icmpv6", "-1"], lower(r.protocol))])
    error_message = "Egress rule protocol must be one of: tcp, udp, icmp, icmpv6, -1."
  }
}

variable "tags" {
  description = "Additional tags for the Security Group."
  type        = map(string)
  default     = {}
}
