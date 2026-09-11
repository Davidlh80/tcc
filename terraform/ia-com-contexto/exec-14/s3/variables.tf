variable "environment" {
  description = "Ambiente do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O ambiente deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema (ex.: tcc). Use letras minúsculas, números e hífens."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "O sistema deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "region" {
  description = "Região AWS para o provider (ex.: us-east-1)."
  type        = string

  validation {
    condition     = length(var.region) > 0
    error_message = "A região não pode ser vazia."
  }
}

variable "additional_tags" {
  description = "Mapa de tags adicionais a serem aplicadas aos recursos."
  type        = map(string)
  default     = {}
}

variable "purpose" {
  description = "Finalidade do bucket (ex.: logs, assets, backups)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.purpose)) && length(var.purpose) > 0
    error_message = "A finalidade deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "versioning_status" {
  description = "Status do versionamento do bucket. Use Enabled (padrão) ou Suspended."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "versioning_status deve ser Enabled ou Suspended."
  }
}
