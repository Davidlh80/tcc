variable "aws_region" {
  description = "AWS region where the Security Group will be created."
  type        = string
}

variable "security_group_name" {
  description = "Name of the Security Group."
  type        = string
}

variable "vpc_id" {
  description = "ID of the existing VPC for the Security Group."
  type        = string
}

variable "environment" {
  description = "Environment associated with the Security Group."
  type        = string
}

variable "allowed_ports" {
  description = "TCP ports allowed for both ingress and egress."
  type        = set(number)
  nullable    = false

  validation {
    condition = (
      length(var.allowed_ports) > 0 &&
      alltrue([
        for port in var.allowed_ports :
        try(port >= 1 && port <= 65535 && floor(port) == port, false)
      ])
    )

    error_message = "allowed_ports must contain integers between 1 and 65535."
  }
}

variable "allowed_cidrs" {
  description = "IPv4 networks allowed for both ingress and egress, excluding /0."
  type        = set(string)
  nullable    = false

  validation {
    condition = (
      length(var.allowed_cidrs) > 0 &&
      alltrue([
        for cidr in var.allowed_cidrs :
        try(cidrnetmask(cidr) != "0.0.0.0" && cidrsubnet(cidr, 0, 0) == cidr, false)
      ])
    )

    error_message = "allowed_cidrs must contain canonical IPv4 networks, such as 10.0.1.0/24, and cannot contain /0."
  }
}

variable "tags" {
  description = "Additional tags applied to the Security Group and its rules."
  type        = map(string)
  default     = {}
}
