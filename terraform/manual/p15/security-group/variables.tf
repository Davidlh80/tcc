variable "aws_region" {
  description = "Região da AWS"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefixo dos nomes dos recursos"
  type        = string
  default     = "estudo-terraform"

  validation {
    condition     = can(regex("^[a-z0-9-]{3,30}$", var.project_name))
    error_message = "Use apenas letras minúsculas, números e hífen (3 a 30 caracteres)."
  }
}

variable "environment" {
  description = "Ambiente (dev, hml, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "hml", "prod"], var.environment)
    error_message = "O ambiente deve ser dev, hml ou prod."
  }
}

variable "allowed_https_cidrs" {
  description = "IPs que podem acessar a porta 443"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "admin_ssh_cidr" {
  description = "Seu IP público para SSH (ex.: 203.0.113.10/32). Descubra em https://checkip.amazonaws.com"
  type        = string

  validation {
    condition     = can(cidrhost(var.admin_ssh_cidr, 0)) && var.admin_ssh_cidr != "0.0.0.0/0"
    error_message = "Informe um CIDR restrito. 0.0.0.0/0 não é permitido para SSH."
  }
}
