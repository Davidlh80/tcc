variable "region" {
  description = "Região AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z0-9-]+-[0-9]+$", var.region))
    error_message = "Forneça uma região AWS válida, por exemplo: us-east-1, eu-west-1."
  }
}

variable "bucket_name" {
  description = "Nome do bucket S3 (deve ser globalmente único)."
  type        = string

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63 && can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name deve ter entre 3 e 63 caracteres, contendo apenas letras minúsculas, números, pontos e hifens, e não pode iniciar ou terminar com ponto/hífen."
  }
}

variable "tags" {
  description = "Mapa de tags adicionais a serem aplicadas aos recursos."
  type        = map(string)
  default     = {}
}

variable "enable_versioning" {
  description = "Habilita versionamento do bucket."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo que contenha objetos."
  type        = bool
  default     = false
}

variable "block_public_access" {
  description = "Bloqueia todo acesso público ao bucket (quatro flags de Public Access Block)."
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia do lado do servidor. Valores: AES256 ou aws:kms."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser AES256 ou aws:kms."
  }
}

variable "kms_key_arn" {
  description = "ARN da KMS Key para criptografia SSE-KMS (obrigatório quando sse_algorithm = aws:kms)."
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_arn == null || can(regex("^arn:aws(-[a-z0-9]+)?:kms:[a-z0-9-]+:\\d{12}:key\\/.+$", var.kms_key_arn))
    error_message = "kms_key_arn, quando informado, deve ser um ARN de KMS válido: arn:aws:kms:REGION:ACCOUNT_ID:key/KEY_ID."
  }
}

variable "attach_bucket_policy" {
  description = "Anexa uma bucket policy com exigência de TLS e uploads criptografados."
  type        = bool
  default     = true
}

variable "logging_enabled" {
  description = "Habilita Server Access Logging do S3."
  type        = bool
  default     = false
}

variable "logging_target_bucket" {
  description = "Bucket de destino para os logs de acesso (deve existir previamente e permitir writes). Obrigatório se logging_enabled = true."
  type        = string
  default     = null
}

variable "logging_target_prefix" {
  description = "Prefixo (pasta) para os logs no bucket de destino."
  type        = string
  default     = null
}

variable "abort_incomplete_mpu_days" {
  description = "Dias para abortar uploads multipart incompletos."
  type        = number
  default     = 7

  validation {
    condition     = var.abort_incomplete_mpu_days >= 1 && var.abort_incomplete_mpu_days <= 365
    error_message = "abort_incomplete_mpu_days deve estar entre 1 e 365."
  }
}

variable "noncurrent_expiration_days" {
  description = "Número de dias para expirar versões não correntes (aplica-se quando o versionamento está habilitado). Defina null para desabilitar."
  type        = number
  default     = null

  validation {
    condition     = var.noncurrent_expiration_days == null || var.noncurrent_expiration_days >= 1
    error_message = "noncurrent_expiration_days deve ser null ou um número inteiro >= 1."
  }
}
