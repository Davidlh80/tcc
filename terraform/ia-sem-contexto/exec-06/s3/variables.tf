variable "aws_region" {
  description = "Região AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "Informe uma região válida (ex: us-east-1, eu-west-1, sa-east-1)."
  }
}

variable "bucket_name" {
  description = "Nome do bucket S3 (globalmente único). Apenas letras minúsculas, números e hífens; 3-63 caracteres; não use pontos."
  type        = string

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63 && can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name deve ter 3-63 caracteres, começar e terminar com letra/número, e conter apenas letras minúsculas, números e hífens."
  }
}

variable "enable_versioning" {
  description = "Habilita versionamento no bucket."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo com objetos (use com cautela)."
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "ARN da KMS Key para criptografia SSE-KMS. Deixe vazio para usar SSE-S3 (AES256)."
  type        = string
  default     = ""

  validation {
    condition     = var.kms_key_arn == "" || can(regex("^arn:aws[a-zA-Z-\\-]*:kms:[a-z0-9-]+:\\d{12}:key\\/[a-f0-9-]+$", var.kms_key_arn))
    error_message = "kms_key_arn deve ser vazio ou um ARN de chave KMS válido."
  }
}

variable "sse_kms_bucket_key_enabled" {
  description = "Habilita S3 Bucket Keys para reduzir custo de requisições KMS quando usando SSE-KMS."
  type        = bool
  default     = true
}

variable "logging_enabled" {
  description = "Habilita Server Access Logging no bucket."
  type        = bool
  default     = false
}

variable "logging_target_bucket" {
  description = "Bucket alvo para armazenar os logs de acesso (necessário se logging_enabled = true)."
  type        = string
  default     = ""
}

variable "logging_target_prefix" {
  description = "Prefixo para os logs de acesso no bucket alvo."
  type        = string
  default     = "s3-access-logs/"
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

variable "noncurrent_version_expiration_days" {
  description = "Dias para expirar versões não correntes (0 para desabilitar)."
  type        = number
  default     = 0

  validation {
    condition     = var.noncurrent_version_expiration_days >= 0
    error_message = "noncurrent_version_expiration_days deve ser >= 0."
  }
}

variable "current_version_expiration_days" {
  description = "Dias para expirar objetos na versão corrente (0 para desabilitar)."
  type        = number
  default     = 0

  validation {
    condition     = var.current_version_expiration_days >= 0
    error_message = "current_version_expiration_days deve ser >= 0."
  }
}

variable "attach_secure_transport_policy" {
  description = "Anexa uma política que nega acesso sem HTTPS (aws:SecureTransport = false)."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Mapa de tags adicionais para aplicar via default_tags do provider."
  type        = map(string)
  default     = {}
}
