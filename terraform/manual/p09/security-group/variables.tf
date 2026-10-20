variable "region" {
  type        = string
  description = "Region to allocate the created resource"
  default     = "us-east-1"
}

variable "name" {
  type        = string
  description = "Security group name"
}

variable "owner" {
  type        = string
  description = "E-mail of the owner of the resource"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the security group will be created"
}

variable "environment" {
  type        = string
  description = "Environment (dev, hml or prd)"

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment must be dev, hml or prd."
  }
}

variable "allowed_ports" {
  type        = list(number)
  description = "TCP ports allowed for inbound traffic"
}

variable "allowed_cidrs" {
  type        = list(string)
  description = "CIDR blocks allowed for inbound traffic"
}
