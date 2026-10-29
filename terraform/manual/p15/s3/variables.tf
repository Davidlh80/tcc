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
