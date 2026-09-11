variable "environment" {
  description = "Ambiente alvo do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/aplicação para compor o nome do recurso."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) >= 2
    error_message = "system deve conter apenas letras minúsculas, números e hífens, com tamanho mínimo de 2 caracteres."
  }
}

variable "region" {
  description = "Região AWS onde o bucket S3 será criado (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "region deve seguir o formato de regiões AWS (ex.: us-east-1)."
  }
}

variable "purpose" {
  description = "Finalidade do bucket para compor o nome do recurso (ex.: logs, assets, backups)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.purpose)) && length(var.purpose) >= 3
    error_message = "purpose deve conter apenas letras minúsculas, números e hífens, com tamanho mínimo de 3 caracteres."
  }
}

variable "versioning_status" {
  description = "Status do versionamento do bucket S3. Valores permitidos: Enabled, Suspended. Padrão: Enabled."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "versioning_status deve ser Enabled ou Suspended."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas aos recursos. Tags obrigatórias são sempre aplicadas e prevalecem."
  type        = map(string)
  default     = {}
}
