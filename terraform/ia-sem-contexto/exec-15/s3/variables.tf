variable "region" {
  description = "Regiao AWS para o provider."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(var.region) > 0
    error_message = "region nao pode ser vazia."
  }
}

variable "bucket_name" {
  description = "Nome do bucket S3 (globalmente unico)."
  type        = string

  validation {
    condition = (
      length(var.bucket_name) >= 3 &&
      length(var.bucket_name) <= 63 &&
      can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name)) &&
      !can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+$", var.bucket_name)) &&
      !can(regex("\\.\\.", var.bucket_name))
    )
    error_message = "bucket_name deve ter 3-63 chars, somente letras minusculas, numeros, pontos e hifens; nao pode parecer um IP; sem pontos consecutivos; e nao pode comecar/terminar com ponto ou hifen."
  }
}

variable "versioning_enabled" {
  description = "Habilita versionamento no bucket."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo contendo objetos."
  type        = bool
  default     = false
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia do S3. Use AES256 (padrão) ou aws:kms."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser 'AES256' ou 'aws:kms'."
  }
}

variable "kms_key_arn" {
  description = "ARN da CMK do KMS quando sse_algorithm for 'aws:kms'. Se ausente, usa a chave gerenciada aws/s3."
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_arn == null || can(regex("^arn:aws(-[a-z]+)?:kms:[a-z0-9-]+:\\d{12}:key\\/.+", var.kms_key_arn))
    error_message = "kms_key_arn deve ser um ARN valido de chave KMS ou null."
  }
}

variable "bucket_key_enabled" {
  description = "Habilita S3 Bucket Keys para reduzir custos de KMS (apenas quando aws:kms)."
  type        = bool
  default     = true
}

variable "lifecycle_abort_incomplete_multipart_upload_days" {
  description = "Dias para abortar uploads multipart incompletos."
  type        = number
  default     = 7

  validation {
    condition     = var.lifecycle_abort_incomplete_multipart_upload_days >= 1 && var.lifecycle_abort_incomplete_multipart_upload_days <= 365
    error_message = "lifecycle_abort_incomplete_multipart_upload_days deve estar entre 1 e 365."
  }
}

variable "lifecycle_expiration_days" {
  description = "Dias para expiracao de objetos (opcional). Use null para desabilitar."
  type        = number
  default     = null

  validation {
    condition     = var.lifecycle_expiration_days == null || var.lifecycle_expiration_days >= 1
    error_message = "lifecycle_expiration_days deve ser null ou >= 1."
  }
}

variable "enable_bucket_policy" {
  description = "Cria uma bucket policy para negar trafego sem TLS."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags adicionais a aplicar ao bucket e como default_tags no provider."
  type        = map(string)
  default     = {}
}
