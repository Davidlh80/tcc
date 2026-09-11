variable "region" {
  description = "Região AWS onde os recursos serão provisionados."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "A variável region deve estar no formato de região AWS válido (ex.: us-east-1, sa-east-1)."
  }
}

variable "environment" {
  description = "Ambiente alvo para o recurso (dev, hml, prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores permitidos: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/aplicação segundo o padrão organizacional."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 1
    error_message = "system deve conter apenas letras minúsculas, números e hífens, com ao menos 2 caracteres."
  }
}

variable "purpose" {
  description = "Finalidade do bucket segundo o padrão organizacional (ex.: logs, assets, backups)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.purpose)) && length(var.purpose) > 1
    error_message = "purpose deve conter apenas letras minúsculas, números e hífens, com ao menos 2 caracteres."
  }
}

variable "versioning_status" {
  description = "Status do versionamento do bucket S3. Valores permitidos: Enabled, Suspended."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "versioning_status deve ser Enabled ou Suspended."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas aos recursos (sobrescrevem chaves iguais)."
  type        = map(string)
  default     = {}
}
