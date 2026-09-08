variable "region" {
  type        = string
  description = "Região AWS para o provider."
  default     = "us-east-1"
  validation {
    condition     = length(var.region) > 0
    error_message = "A região não pode ser vazia."
  }
}

variable "bucket_name" {
  type        = string
  description = "Nome único global do bucket S3."
  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres."
  }
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]+[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve conter apenas letras minúsculas, números, pontos e hífens; iniciar e terminar com letra/número."
  }
}

variable "force_destroy" {
  type        = bool
  description = "Permite destruir o bucket mesmo com objetos."
  default     = false
}

variable "enable_versioning" {
  type        = bool
  description = "Habilita versionamento no bucket."
  default     = true
}

variable "sse_algorithm" {
  type        = string
  description = "Algoritmo de criptografia do lado do servidor (AES256 ou aws:kms)."
  default     = "AES256"
  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser 'AES256' ou 'aws:kms'."
  }
}

variable "sse_kms_key_arn" {
  type        = string
  description = "ARN da KMS Key quando sse_algorithm='aws:kms'."
  default     = ""
  validation {
    condition     = var.sse_algorithm != "aws:kms" || (var.sse_algorithm == "aws:kms" && length(var.sse_kms_key_arn) > 0)
    error_message = "Quando sse_algorithm='aws:kms', sse_kms_key_arn deve ser informado."
  }
}

variable "block_public_acls" {
  type        = bool
  description = "Bloqueia ACLs públicas no bucket."
  default     = true
}

variable "ignore_public_acls" {
  type        = bool
  description = "Ignora ACLs públicas aplicadas aos objetos."
  default     = true
}

variable "block_public_policy" {
  type        = bool
  description = "Bloqueia políticas públicas no bucket."
  default     = true
}

variable "restrict_public_buckets" {
  type        = bool
  description = "Restringe buckets públicos a somente acesso via políticas específicas."
  default     = true
}

variable "logging_target_bucket" {
  type        = string
  description = "Bucket de destino para Server Access Logging. Deixe vazio para desabilitar."
  default     = ""
}

variable "logging_target_prefix" {
  type        = string
  description = "Prefixo para logs no bucket de destino. Usado somente se logging_target_bucket for definido."
  default     = ""
}

variable "abort_incomplete_multipart_days" {
  type        = number
  description = "Dias para abortar uploads multipart incompletos."
  default     = 7
  validation {
    condition     = var.abort_incomplete_multipart_days >= 1 && var.abort_incomplete_multipart_days <= 30
    error_message = "abort_incomplete_multipart_days deve estar entre 1 e 30."
  }
}

variable "noncurrent_version_expiration_days" {
  type        = number
  description = "Dias para expirar versões não correntes. 0 desabilita."
  default     = 0
  validation {
    condition     = var.noncurrent_version_expiration_days >= 0
    error_message = "noncurrent_version_expiration_days deve ser >= 0."
  }
}

variable "create_bucket_policy_https_only" {
  type        = bool
  description = "Cria política que nega acesso sem TLS (HTTPS) ao bucket."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais para o bucket."
  default     = {}
}
