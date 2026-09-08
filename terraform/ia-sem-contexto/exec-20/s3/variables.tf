variable "aws_region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(var.aws_region) > 0
    error_message = "A regiao AWS nao pode ser vazia."
  }
}

variable "bucket_name" {
  description = "Nome do bucket S3 (deve ser unico globalmente)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name deve conter de 3 a 63 caracteres, apenas letras minusculas, numeros, hifens e pontos, com inicio e fim alfanumericos."
  }
}

variable "versioning_enabled" {
  description = "Habilita versionamento no bucket."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo se houver objetos."
  type        = bool
  default     = false
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia padrao do bucket. Use AES256 ou aws:kms."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser 'AES256' ou 'aws:kms'."
  }
}

variable "sse_kms_key_arn" {
  description = "ARN da chave KMS para criptografia (necessario apenas se desejar chave especifica com aws:kms)."
  type        = string
  default     = null

  validation {
    condition = (
      var.sse_kms_key_arn == null ||
      can(regex("^arn:aws(-[a-z]+)?:kms:[a-z0-9-]+:\\d{12}:key\\/[a-f0-9-]{36}$", var.sse_kms_key_arn))
    )
    error_message = "Quando informado, sse_kms_key_arn deve ser um ARN valido de chave KMS."
  }

  validation {
    condition     = var.sse_algorithm == "aws:kms" || var.sse_kms_key_arn == null
    error_message = "sse_kms_key_arn deve ser nulo quando sse_algorithm for AES256."
  }
}

variable "enforce_sse_in_put_policy" {
  description = "Se verdadeiro, aplica politica que exige header de SSE nos uploads (Pode quebrar clientes que nao enviam o header)."
  type        = bool
  default     = false
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
  description = "Dias para expirar versoes nao correntes. Use 0 para desabilitar."
  type        = number
  default     = 90

  validation {
    condition     = var.noncurrent_version_expiration_days >= 0
    error_message = "noncurrent_version_expiration_days deve ser >= 0."
  }
}

variable "block_public_acls" {
  description = "Bloqueia ACLs publicas do bucket."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Bloqueia politicas publicas do bucket."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignora ACLs publicas em objetos."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restringe acesso publico ao bucket."
  type        = bool
  default     = true
}

variable "object_ownership" {
  description = "Modo de propriedade de objetos do bucket."
  type        = string
  default     = "BucketOwnerEnforced"

  validation {
    condition     = contains(["BucketOwnerEnforced", "BucketOwnerPreferred", "ObjectWriter"], var.object_ownership)
    error_message = "object_ownership deve ser 'BucketOwnerEnforced', 'BucketOwnerPreferred' ou 'ObjectWriter'."
  }
}

variable "tags" {
  description = "Mapa de tags a serem aplicadas aos recursos."
  type        = map(string)
  default     = {}
}
