variable "environment" {
  description = "Ambiente do recurso (dev, hml, prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/produto (ex.: tcc). Use letras minúsculas, números e hifens."
  type        = string

  validation {
    condition     = length(var.system) > 0 && can(regex("^[a-z0-9-]+$", var.system))
    error_message = "system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS para criação dos recursos (ex.: us-east-1)."
  type        = string

  validation {
    condition     = length(var.region) > 0
    error_message = "region não pode ser vazia."
  }
}

variable "purpose" {
  description = "Finalidade do bucket S3 (ex.: logs, artifacts, backups)."
  type        = string

  validation {
    condition     = length(var.purpose) > 0 && can(regex("^[a-z0-9-]+$", var.purpose))
    error_message = "purpose deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas aos recursos (sobrescrevem chaves iguais)."
  type        = map(string)
  default     = {}
}

variable "force_destroy" {
  description = "Se true, permite destruir o bucket mesmo com objetos (use com cautela)."
  type        = bool
  default     = false
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia server-side. Padrão AES256 (SSE-S3). Aceita: AES256, aws:kms."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser 'AES256' ou 'aws:kms'."
  }
}

variable "kms_key_id" {
  description = "KMS Key ID/ARN para criptografia quando sse_algorithm = 'aws:kms'. Se omitido, usa a chave AWS gerenciada (aws/s3)."
  type        = string
  default     = null
}

variable "versioning_status" {
  description = "Status do versionamento do bucket. Aceita: Enabled, Suspended. Padrão Enabled."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "versioning_status deve ser 'Enabled' ou 'Suspended'."
  }
}
