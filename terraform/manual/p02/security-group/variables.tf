variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "security_group_name" {
  type    = string
  default = "app-security-group"
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR autorizado para SSH"
  type        = string

  validation {
    condition = (
      can(cidrhost(var.allowed_ssh_cidr, 0)) &&
      can(regex("^[0-9.]+/[0-9]+$", var.allowed_ssh_cidr))
    )
    error_message = "Informe um CIDR IPv4 valido."
  }
}
