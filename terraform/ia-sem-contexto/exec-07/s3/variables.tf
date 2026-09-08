variable "bucket_name" {
  description = "Nome globalmente único do bucket S3."
  type        = string

  validation {
    condition = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "bucket_name deve ter entre 3 e 63 caracteres."
  }

  validation {
    condition = can(regex("^[a-z0-9]([a-z0-9.-]*[a-z0-9])?$", var.bucket_name))
    error_message = "bucket_name deve conter apenas letras minúsculas, números, pontos e hifens; iniciar e terminar com alfanumérico."
  }

  validation {
    condition     = length(regexall("\\.\\.", var.bucket_name)) == 0
    error_message = "bucket_name não pode conter '..' (pontos consecutivos)."
  }
}

variable "region" {
  description = "Região AWS para o bucket."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(var.region) > 0
    error_message = "region não pode ser vazio."
  }
}

variable "environment" {
  description = "Identificador do ambiente (ex.: dev, stage, prod). Usado em tags."
  type        = string
  default     = "dev"
}

variable "versioning_enabled" {
  description = "Ativa versionamento do bucket."
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia no lado do servidor (AES256 ou aws:kms)."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser 'AES256' ou 'aws:kms'."
  }
}

variable "kms_key_id" {
  description = "ID ou ARN da CMK KMS quando sse_algorithm = aws:kms."
  type        = string
  default     = null

  validation {
    condition     = var.sse_algorithm != "aws:kms" || (var.kms_key_id != null && trim(var.kms_key_id) != "")
    error_message = "kms_key_id deve ser definido quando sse_algorithm for 'aws:kms'."
  }
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo com objetos (use com cautela)."
  type        = bool
  default     = false
}

variable "logging_target_bucket" {
  description = "Bucket de destino para access logs (opcional)."
  type        = string
  default     = null
}

variable "logging_target_prefix" {
  description = "Prefixo para objetos de access logs."
  type        = string
  default     = "logs/"
}

variable "enable_lifecycle_rules" {
  description = "Habilita regras de ciclo de vida padrão."
  type        = bool
  default     = true
}

variable "noncurrent_version_expiration_days" {
  description = "Dias para expirar versões não correntes."
  type        = number
  default     = 90

  validation {
    condition     = var.noncurrent_version_expiration_days >= 1
    error_message = "noncurrent_version_expiration_days deve ser >= 1."
  }
}

variable "abort_incomplete_multipart_upload_days" {
  description = "Dias para abortar uploads multipart incompletos."
  type        = number
  default     = 7

  validation {
    condition     = var.abort_incomplete_multipart_upload_days >= 1 && var.abort_incomplete_multipart_upload_days <= 365
    error_message = "abort_incomplete_multipart_upload_days deve estar entre 1 e 365."
  }
}

variable "attach_tls_enforce_policy" {
  description = "Anexa política para exigir TLS (https) em todas as requisições."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Mapa de tags adicionais."
  type        = map(string)
  default     = {}
}
