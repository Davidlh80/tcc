variable "aws_region" {
  description = "Região AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "Informe uma região válida (ex: us-east-1, eu-west-1)."
  }
}

variable "bucket_name" {
  description = "Nome do bucket S3 (precisa ser globalmente único)."
  type        = string

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63 && can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usar apenas letras minúsculas, números, pontos e hifens, e começar/terminar com letra ou número."
  }
}

variable "versioning_enabled" {
  description = "Habilita versionamento do bucket."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo com objetos (atenção: dados serão removidos)."
  type        = bool
  default     = false
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia no lado do servidor (AES256 ou aws:kms)."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser AES256 ou aws:kms."
  }
}

variable "kms_key_id" {
  description = "ID/ARN da KMS Key a ser usada quando sse_algorithm = aws:kms. Opcional; se não informado, será usada a chave gerenciada pela AWS."
  type        = string
  default     = null
}

variable "bucket_key_enabled" {
  description = "Habilita S3 Bucket Keys para reduzir custos com KMS (aplicável quando aws:kms)."
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
  description = "Ignora ACLs públicas."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restringe buckets públicos apenas a usuários autorizados."
  type        = bool
  default     = true
}

variable "logging_enabled" {
  description = "Habilita logs de acesso do S3."
  type        = bool
  default     = false
}

variable "logging_bucket" {
  description = "Bucket de destino para logs de acesso do S3 (precisa existir). Necessário se logging_enabled=true."
  type        = string
  default     = null
}

variable "logging_prefix" {
  description = "Prefixo para objetos de log."
  type        = string
  default     = "s3-access-logs/"
}

variable "lifecycle_enabled" {
  description = "Cria configuração de ciclo de vida padrão (abortar uploads multipart incompletos)."
  type        = bool
  default     = true
}

variable "abort_incomplete_multipart_upload_days" {
  description = "Dias para abortar uploads multipart incompletos."
  type        = number
  default     = 7

  validation {
    condition     = var.abort_incomplete_multipart_upload_days >= 1 && var.abort_incomplete_multipart_upload_days <= 30
    error_message = "Defina entre 1 e 30 dias para abortar uploads multipart incompletos."
  }
}

variable "noncurrent_version_expiration_days" {
  description = "Dias para expirar versões não correntes. Se null, não aplica regra."
  type        = number
  default     = null

  validation {
    condition     = var.noncurrent_version_expiration_days == null || var.noncurrent_version_expiration_days >= 1
    error_message = "Quando definido, noncurrent_version_expiration_days deve ser >= 1."
  }
}

variable "enforce_ssl_only" {
  description = "Cria política para negar requests sem TLS."
  type        = bool
  default     = true
}

variable "enforce_sse" {
  description = "Cria política para exigir criptografia do lado do servidor nos uploads."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags adicionais para o bucket."
  type        = map(string)
  default     = {}
}
