variable "region" {
  type        = string
  description = "Região AWS para o provider (ex.: us-east-1)."
  default     = "us-east-1"
}

variable "bucket_name" {
  type        = string
  description = "Nome globalmente único do bucket S3 (3-63 chars, minúsculas, números e hífens)."
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name deve ter 3-63 caracteres, usar apenas letras minúsculas, números e hífens, e não pode iniciar/terminar com hífen."
  }
}

variable "force_destroy" {
  type        = bool
  description = "Se true, permite destruir o bucket mesmo se contiver objetos."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais a aplicar no bucket."
  default     = {}
}

variable "versioning_enabled" {
  type        = bool
  description = "Se true, habilita versionamento no bucket."
  default     = true
}

variable "sse_algorithm" {
  type        = string
  description = "Algoritmo de criptografia padrão do bucket: AES256 ou aws:kms."
  default     = "aws:kms"
  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser 'AES256' ou 'aws:kms'."
  }
}

variable "kms_key_arn" {
  type        = string
  description = "ARN da KMS Key para criptografia SSE-KMS. Se vazio/nulo, usa a chave gerenciada AWS S3 (alias/aws/s3)."
  default     = null
  validation {
    condition     = var.sse_algorithm != "aws:kms" || var.kms_key_arn == null || trim(var.kms_key_arn) != ""
    error_message = "Quando sse_algorithm = 'aws:kms', kms_key_arn deve ser nulo (para usar alias/aws/s3) ou um ARN não-vazio."
  }
}

variable "bucket_key_enabled" {
  type        = bool
  description = "Habilita S3 Bucket Keys para reduzir custos com SSE-KMS."
  default     = true
}

variable "block_public_acls" {
  type        = bool
  description = "Bloqueia ACLs públicas."
  default     = true
}

variable "block_public_policy" {
  type        = bool
  description = "Bloqueia políticas públicas no bucket."
  default     = true
}

variable "ignore_public_acls" {
  type        = bool
  description = "Ignora ACLs públicas existentes."
  default     = true
}

variable "restrict_public_buckets" {
  type        = bool
  description = "Restringe buckets públicos apenas a acessos por políticas de conta."
  default     = true
}

variable "enable_access_logging" {
  type        = bool
  description = "Se true, habilita Server Access Logging (requer bucket de logs pré-existente)."
  default     = false
}

variable "logging_target_bucket" {
  type        = string
  description = "Bucket destino para logs de acesso (deve existir e ser diferente do bucket principal). Obrigatório se enable_access_logging=true."
  default     = null
  validation {
    condition     = !var.enable_access_logging || try(var.logging_target_bucket != null && trim(var.logging_target_bucket) != "" && var.logging_target_bucket != var.bucket_name, false)
    error_message = "logging_target_bucket deve ser definido, não-vazio e diferente de bucket_name quando enable_access_logging=true."
  }
}

variable "logging_target_prefix" {
  type        = string
  description = "Prefixo dos objetos de log no bucket de destino."
  default     = "logs/"
}

variable "lifecycle_abort_incomplete_multipart_upload_days" {
  type        = number
  description = "Dias para abortar uploads multipart incompletos."
  default     = 7
  validation {
    condition     = var.lifecycle_abort_incomplete_multipart_upload_days > 0
    error_message = "lifecycle_abort_incomplete_multipart_upload_days deve ser maior que 0."
  }
}

variable "lifecycle_expiration_days" {
  type        = number
  description = "Remove objetos após N dias. Use null para desabilitar."
  default     = null
  validation {
    condition     = var.lifecycle_expiration_days == null || var.lifecycle_expiration_days > 0
    error_message = "lifecycle_expiration_days deve ser null ou maior que 0."
  }
}

variable "noncurrent_version_expiration_days" {
  type        = number
  description = "Remove versões não atuais após N dias. Use null para desabilitar."
  default     = null
  validation {
    condition     = var.noncurrent_version_expiration_days == null || var.noncurrent_version_expiration_days > 0
    error_message = "noncurrent_version_expiration_days deve ser null ou maior que 0."
  }
}
