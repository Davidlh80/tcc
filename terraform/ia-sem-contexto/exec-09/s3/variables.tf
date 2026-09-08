variable "aws_region" {
  description = "Regiao AWS onde o bucket S3 sera criado (ex.: us-east-1)."
  type        = string
  validation {
    condition     = length(var.aws_region) > 0
    error_message = "aws_region nao pode ser vazio."
  }
}

variable "bucket_name" {
  description = "Nome do bucket S3 (deve ser globalmente unico)."
  type        = string
  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "bucket_name deve ter entre 3 e 63 caracteres."
  }
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name deve conter apenas letras minusculas, numeros, hifens e pontos; e nao pode iniciar/terminar com ponto."
  }
  validation {
    condition     = !contains(var.bucket_name, "..")
    error_message = "bucket_name nao pode conter dois pontos consecutivos."
  }
  validation {
    condition     = !can(regex("^\\d{1,3}(?:\\.\\d{1,3}){3}$", var.bucket_name))
    error_message = "bucket_name nao pode ser um endereco IPv4."
  }
}

variable "force_destroy" {
  description = "Se true, permite destruir o bucket mesmo se nao estiver vazio."
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Habilita o versionamento do bucket."
  type        = bool
  default     = true
}

variable "enable_lifecycle_rules" {
  description = "Cria regras de ciclo de vida padrao (abort multipart, expiracao de versoes antigas e opcionalmente expiracao de objetos)."
  type        = bool
  default     = true
}

variable "lifecycle_abort_multipart_days" {
  description = "Dias para abortar uploads multipart incompletos."
  type        = number
  default     = 7
  validation {
    condition     = var.lifecycle_abort_multipart_days >= 1 && var.lifecycle_abort_multipart_days <= 365
    error_message = "lifecycle_abort_multipart_days deve estar entre 1 e 365."
  }
}

variable "lifecycle_noncurrent_version_expiration_days" {
  description = "Dias para expirar versoes nao correntes (quando versionamento estiver ativo)."
  type        = number
  default     = 30
  validation {
    condition     = var.lifecycle_noncurrent_version_expiration_days >= 1
    error_message = "lifecycle_noncurrent_version_expiration_days deve ser >= 1."
  }
}

variable "lifecycle_expiration_days" {
  description = "Dias para expirar objetos atuais. Use null para nao expirar."
  type        = number
  default     = null
  validation {
    condition     = var.lifecycle_expiration_days == null || var.lifecycle_expiration_days >= 1
    error_message = "lifecycle_expiration_days deve ser null ou >= 1."
  }
}

variable "logging_enabled" {
  description = "Habilita Server Access Logging."
  type        = bool
  default     = false
}

variable "logging_target_bucket" {
  description = "Bucket alvo para logs de acesso (exigido quando logging_enabled = true)."
  type        = string
  default     = null
}

variable "logging_target_prefix" {
  description = "Prefixo para os logs de acesso."
  type        = string
  default     = "s3-access-logs/"
}

variable "kms_key_id" {
  description = "ARN ou ID da CMK KMS para criptografia do bucket. Se vazio, usa SSE-S3 (AES256)."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas aos recursos."
  type        = map(string)
  default     = {}
}
