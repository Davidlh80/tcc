variable "aws_region" {
  type        = string
  description = "Região AWS onde os recursos serão criados (ex.: us-east-1)."
  default     = "us-east-1"
}

variable "bucket_name" {
  type        = string
  description = "Nome globalmente único do bucket S3."
  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "bucket_name deve ter entre 3 e 63 caracteres."
  }
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name deve conter apenas letras minúsculas, números, pontos e hifens; deve começar e terminar com letra ou número."
  }
}

variable "versioning_enabled" {
  type        = bool
  description = "Habilita versionamento no bucket."
  default     = true
}

variable "force_destroy" {
  type        = bool
  description = "Permite destruir o bucket mesmo com objetos dentro."
  default     = false
}

variable "kms_key_arn" {
  type        = string
  description = "ARN da chave KMS para criptografia SSE-KMS. Se vazio/nulo, usa SSE-S3 (AES256)."
  default     = null
  validation {
    condition = var.kms_key_arn == null || trim(var.kms_key_arn) == "" || can(regex("^arn:aws(-[a-z-]+)?:kms:[a-z0-9-]+:\\d{12}:key\\/.+$", var.kms_key_arn))
    error_message = "kms_key_arn deve ser um ARN de chave KMS válido ou estar vazio."
  }
}

variable "lifecycle_abort_incomplete_multipart_upload_days" {
  type        = number
  description = "Dias para abortar uploads multipart incompletos. Use 0 para desabilitar."
  default     = 7
  validation {
    condition     = var.lifecycle_abort_incomplete_multipart_upload_days == 0 || var.lifecycle_abort_incomplete_multipart_upload_days >= 1
    error_message = "Defina 0 para desabilitar ou um valor inteiro >= 1."
  }
}

variable "enforce_tls_only" {
  type        = bool
  description = "Cria política que nega acesso sem TLS (aws:SecureTransport=false)."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais para aplicar ao bucket."
  default     = {}
}
