variable "environment" {
  description = "Ambiente do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema (ex.: tcc). Usado na composição do nome do bucket."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "purpose" {
  description = "Finalidade do bucket (ex.: logs, assets, backups)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.purpose)) && length(var.purpose) > 0
    error_message = "purpose deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "region" {
  description = "Região AWS para o provisionamento (ex.: us-east-1)."
  type        = string

  validation {
    condition     = length(var.region) > 0
    error_message = "region não pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas aos recursos. Tags obrigatórias internas sempre prevalecem."
  type        = map(string)
  default     = {}
}

variable "versioning_enabled" {
  description = "Habilita o versionamento do bucket S3. Padrão: true (Enabled)."
  type        = bool
  default     = true
}
