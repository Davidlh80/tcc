variable "environment" {
  description = "Ambiente do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um de: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema/aplicação (minúsculo, números e hífens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS para o provider (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "region deve estar no formato válido (ex.: us-east-1)."
  }
}

variable "purpose" {
  description = "Finalidade do recurso (minúsculo, números e hífens). Usado na composição do nome."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.purpose)) && length(var.purpose) > 0
    error_message = "purpose deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "versioning_status" {
  description = "Status do versionamento do bucket. Valores permitidos: Enabled, Suspended."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "versioning_status deve ser Enabled ou Suspended."
  }
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia server-side. Padrão: AES256. Valores permitidos: AES256, aws:kms."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser AES256 ou aws:kms."
  }
}

variable "kms_key_id" {
  description = "ARN ou ID da KMS Key quando sse_algorithm=aws:kms. Obrigatório apenas neste caso."
  type        = string
  default     = null
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas aos recursos (sem sobrescrever as obrigatórias)."
  type        = map(string)
  default     = {}
}
