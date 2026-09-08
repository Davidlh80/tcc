variable "region" {
  description = "Região AWS onde o bucket será criado."
  type        = string
  default     = "us-east-1"
  validation {
    condition     = length(var.region) > 0
    error_message = "A região não pode ser vazia."
  }
}

variable "bucket_name" {
  description = "Nome do bucket S3 (deve ser globalmente único)."
  type        = string
  validation {
    condition = (
      length(var.bucket_name) >= 3 &&
      length(var.bucket_name) <= 63 &&
      can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.bucket_name)) &&
      length(regexall("\\.\\.", var.bucket_name)) == 0
    )
    error_message = "bucket_name deve ter entre 3 e 63 caracteres, usar apenas letras minúsculas, números, pontos e hífens, iniciar e terminar com letra/número e não conter '..'."
  }
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo se contiver objetos (use com cautela)."
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Habilita versionamento do bucket."
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia do lado do servidor. Opções: AES256 ou aws:kms."
  type        = string
  default     = "AES256"
  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser 'AES256' ou 'aws:kms'."
  }
}

variable "kms_key_arn" {
  description = "ARN da chave KMS para criptografia (obrigatório se sse_algorithm = aws:kms)."
  type        = string
  default     = ""
  validation {
    condition     = var.sse_algorithm == "aws:kms" ? length(var.kms_key_arn) > 0 : true
    error_message = "kms_key_arn deve ser definido quando sse_algorithm = aws:kms."
  }
}

variable "sse_bucket_key_enabled" {
  description = "Habilita S3 Bucket Keys para reduzir custos com KMS ao usar aws:kms."
  type        = bool
  default     = true
}

variable "public_access_block" {
  description = "Configuração de bloqueio de acesso público."
  type = object({
    block_public_acls       = bool
    block_public_policy     = bool
    ignore_public_acls      = bool
    restrict_public_buckets = bool
  })
  default = {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}

variable "logging" {
  description = "Configuração de logging de acesso do S3 para outro bucket."
  type = object({
    enabled       = bool
    target_bucket = string
    target_prefix = string
  })
  default = {
    enabled       = false
    target_bucket = ""
    target_prefix = "s3-access-logs/"
  }
  validation {
    condition     = var.logging.enabled ? length(var.logging.target_bucket) > 0 : true
    error_message = "Quando logging.enabled = true, logging.target_bucket deve ser informado."
  }
}

variable "lifecycle" {
  description = "Regras simples de lifecycle do bucket."
  type = object({
    enabled                                 = bool
    abort_incomplete_multipart_upload_days  = number
    noncurrent_version_expiration_days      = number
  })
  default = {
    enabled                                = true
    abort_incomplete_multipart_upload_days = 7
    noncurrent_version_expiration_days     = 365
  }
  validation {
    condition     = var.lifecycle.abort_incomplete_multipart_upload_days >= 1
    error_message = "abort_incomplete_multipart_upload_days deve ser >= 1."
  }
  validation {
    condition     = var.lifecycle.noncurrent_version_expiration_days >= 1
    error_message = "noncurrent_version_expiration_days deve ser >= 1."
  }
}

variable "tags" {
  description = "Tags a serem aplicadas aos recursos."
  type        = map(string)
  default     = {}
}
