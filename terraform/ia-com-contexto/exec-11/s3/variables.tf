variable "region" {
  type        = string
  description = "Região AWS onde os recursos serão provisionados (ex.: us-east-1)."
  validation {
    condition     = length(var.region) > 0
    error_message = "A variável 'region' não pode ser vazia."
  }
}

variable "environment" {
  type        = string
  description = "Ambiente do recurso (valores permitidos: dev, hml, prd)."
  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O 'environment' deve ser um de: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema/aplicação ao qual o recurso pertence."
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "O 'system' deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "purpose" {
  type        = string
  description = "Finalidade específica do bucket (ex.: logs, assets, backups)."
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.purpose)) && length(var.purpose) > 0
    error_message = "O 'purpose' deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "versioning_status" {
  type        = string
  description = "Status do versionamento do bucket (Enabled ou Suspended)."
  default     = "Enabled"
  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "A variável 'versioning_status' deve ser 'Enabled' ou 'Suspended'."
  }
}

variable "additional_tags" {
  type        = map(string)
  description = "Mapa de tags adicionais a serem aplicadas aos recursos."
  default     = {}
}
