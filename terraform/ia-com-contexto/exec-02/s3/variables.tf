variable "aws_region" {
  description = "Região AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(var.aws_region) > 0
    error_message = "A região AWS (aws_region) não pode ser vazia."
  }
}

variable "environment" {
  description = "Ambiente do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O ambiente deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou aplicação responsável (apenas minúsculas, números e hífen)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) >= 2 && length(var.system) <= 32
    error_message = "O 'system' deve conter 2 a 32 caracteres, usando apenas [a-z0-9-]."
  }
}

variable "purpose" {
  description = "Finalidade do bucket (apenas minúsculas, números e hífen). Ex.: logs, assets, backups."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.purpose)) && length(var.purpose) >= 2 && length(var.purpose) <= 32
    error_message = "A 'purpose' deve conter 2 a 32 caracteres, usando apenas [a-z0-9-]."
  }
}

variable "enable_versioning" {
  description = "Habilita o versionamento do bucket S3 (recomendado true)."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo contendo objetos. Use com cautela (padrão: false)."
  type        = bool
  default     = false
}

variable "additional_tags" {
  description = "Mapa de tags adicionais a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
