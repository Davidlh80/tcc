variable "environment" {
  description = "Ambiente de deploy. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/produto. Use apenas letras minúsculas, números e hífens."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0 && length(var.system) <= 30
    error_message = "O system deve conter apenas [a-z0-9-] e ter entre 1 e 30 caracteres."
  }
}

variable "purpose" {
  description = "Finalidade do bucket (ex.: logs, assets, backups). Use apenas letras minúsculas, números e hífens."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.purpose)) && length(var.purpose) > 0 && length(var.purpose) <= 30
    error_message = "O purpose deve conter apenas [a-z0-9-] e ter entre 1 e 30 caracteres."
  }
}

variable "region" {
  description = "Região AWS para o deploy (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "A região deve seguir o padrão, por exemplo: us-east-1."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas em todos os recursos com suporte a tags."
  type        = map(string)
  default     = {}
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
