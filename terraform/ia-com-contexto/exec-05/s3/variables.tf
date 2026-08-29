variable "environment" {
  description = "Ambiente do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O ambiente deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou aplicação (minúsculo, números e hífen)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) >= 1 && length(var.system) <= 30
    error_message = "O sistema deve conter apenas [a-z0-9-] e ter entre 1 e 30 caracteres."
  }
}

variable "purpose" {
  description = "Finalidade do bucket (minúsculo, números e hífen)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.purpose)) && length(var.purpose) >= 1 && length(var.purpose) <= 30
    error_message = "A finalidade deve conter apenas [a-z0-9-] e ter entre 1 e 30 caracteres."
  }
}

variable "enable_versioning" {
  description = "Habilita versionamento do S3 (recomendado: true)."
  type        = bool
  default     = true
}

variable "aws_region" {
  description = "Região AWS onde os recursos serão criados (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "Informe uma região válida, como us-east-1, us-west-2, sa-east-1."
  }
}

variable "additional_tags" {
  description = "Tags adicionais para adicionar ao bucket."
  type        = map(string)
  default     = {}
}
