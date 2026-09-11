variable "environment" {
  description = "Ambiente alvo do recurso (dev, hml, prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O environment deve ser um dos valores: dev, hml ou prd."
  }
}

variable "system" {
  description = "Identificador do sistema/aplicação (ex.: tcc). Deve estar em minúsculas e pode conter hifens."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "O system deve conter apenas letras minúsculas, números e hifens."
  }
}

variable "region" {
  description = "Região AWS onde o recurso será criado (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d+$", var.region))
    error_message = "A region deve corresponder ao padrão de regiões AWS, por exemplo: us-east-1, sa-east-1."
  }
}

variable "purpose" {
  description = "Finalidade do recurso conforme padrão de nomenclatura (ex.: logs, data, backups)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.purpose)) && length(var.purpose) > 0
    error_message = "O purpose deve conter apenas letras minúsculas, números e hifens."
  }
}

variable "versioning_status" {
  description = "Status do versionamento do bucket S3. Valores permitidos: Enabled ou Suspended."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "versioning_status deve ser Enabled ou Suspended."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas aos recursos."
  type        = map(string)
  default     = {}
}
