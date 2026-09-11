variable "environment" {
  description = "Ambiente do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema/aplicação (minúsculo, números e hífens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) >= 3 && length(var.system) <= 30
    error_message = "system deve conter 3-30 caracteres, apenas [a-z0-9-]."
  }
}

variable "region" {
  description = "Região AWS para o provisionamento (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d+$", var.region))
    error_message = "region deve seguir o padrão de regiões AWS (ex.: us-east-1)."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas às tags obrigatórias."
  type        = map(string)
  default     = {}
}

variable "purpose" {
  description = "Finalidade do bucket seguindo a convenção de nomes (ex.: logs, assets, backups)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.purpose)) && length(var.purpose) >= 3 && length(var.purpose) <= 30
    error_message = "purpose deve conter 3-30 caracteres, apenas [a-z0-9-]."
  }
}

variable "versioning_enabled" {
  description = "Habilita versionamento do bucket S3 (padrão: true => Enabled)."
  type        = bool
  default     = true
}
