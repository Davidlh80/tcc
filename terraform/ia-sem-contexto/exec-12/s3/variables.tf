variable "region" {
  description = "Região AWS onde o bucket será criado."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = trim(var.region) != ""
    error_message = "A região não pode ser vazia."
  }
}

variable "bucket_name" {
  description = "Nome do bucket S3 (deve ser globalmente único)."
  type        = string

  validation {
    condition = length(var.bucket_name) >= 3 &&
    length(var.bucket_name) <= 63 &&
    can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.bucket_name)) &&
    !can(regex("[A-Z_]", var.bucket_name)) &&
    !can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+$", var.bucket_name))
    error_message = "bucket_name deve ter entre 3 e 63 caracteres, usar apenas letras minúsculas, números, hifens e pontos, não parecer um IP e não começar/terminar com separador."
  }
}

variable "force_destroy" {
  description = "Se true, remove o bucket mesmo contendo objetos."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Habilita versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia do lado do servidor (AES256 ou aws:kms)."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser AES256 ou aws:kms."
  }
}

variable "kms_key_id" {
  description = "ID/ARN da CMK KMS para criptografia (opcional, usado quando sse_algorithm=aws:kms)."
  type        = string
  default     = null
}

variable "abort_incomplete_multipart_days" {
  description = "Dias para abortar uploads multipart incompletos."
  type        = number
  default     = 7

  validation {
    condition     = var.abort_incomplete_multipart_days >= 1 && var.abort_incomplete_multipart_days <= 365
    error_message = "abort_incomplete_multipart_days deve estar entre 1 e 365."
  }
}

variable "noncurrent_version_expiration_days" {
  description = "Dias para expirar versões não correntes (0 para desabilitar)."
  type        = number
  default     = 90

  validation {
    condition     = var.noncurrent_version_expiration_days >= 0
    error_message = "noncurrent_version_expiration_days deve ser >= 0."
  }
}

variable "expire_delete_markers" {
  description = "Remove automaticamente delete markers órfãos."
  type        = bool
  default     = true
}

variable "block_public_acls" {
  description = "Bloqueia ACLs públicas."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Bloqueia políticas públicas."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignora ACLs públicas em objetos."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restringe acesso público ao bucket."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Mapa de tags adicionais para aplicar ao bucket."
  type        = map(string)
  default     = {}
}
