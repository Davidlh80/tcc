variable "environment" {
  description = "Ambiente alvo. Deve ser um dos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O environment deve ser um dos: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema (minúsculas, números e hifens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) >= 1 && length(var.system) <= 30
    error_message = "O system deve conter apenas [a-z0-9-] e ter entre 1 e 30 caracteres."
  }
}

variable "purpose" {
  description = "Finalidade do bucket (minúsculas, números e hifens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.purpose)) && length(var.purpose) >= 1 && length(var.purpose) <= 30
    error_message = "O purpose deve conter apenas [a-z0-9-] e ter entre 1 e 30 caracteres."
  }
}

variable "region" {
  description = "Região AWS para o provider."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "A região deve seguir o padrão, por exemplo: us-east-1, sa-east-1."
  }
}

variable "versioning_status" {
  description = "Status do versionamento do bucket. Valores permitidos: Enabled ou Suspended."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "versioning_status deve ser Enabled ou Suspended."
  }
}

variable "force_destroy" {
  description = "Se true, permite destruir o bucket mesmo com objetos (cautela recomendada)."
  type        = bool
  default     = false
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas. Em caso de conflito, as tags padrão prevalecem."
  type        = map(string)
  default     = {}
}
