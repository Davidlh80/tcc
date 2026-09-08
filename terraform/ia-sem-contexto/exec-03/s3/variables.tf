variable "aws_region" {
  description = "Região AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome do bucket S3 (deve ser único globalmente)."
  type        = string

  validation {
    condition = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name)) && !contains(var.bucket_name, "..")
    error_message = "bucket_name deve conter apenas letras minúsculas, números, ponto e hífen; não pode iniciar/terminar com ponto/hífen e não pode conter '..'."
  }
}

variable "versioning_enabled" {
  description = "Habilita versionamento do bucket."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo se houver objetos (use com cautela)."
  type        = bool
  default     = false
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia padrão do bucket. Use 'AES256' (SSE-S3) ou 'aws:kms' (SSE-KMS)."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser 'AES256' ou 'aws:kms'."
  }
}

variable "kms_key_arn" {
  description = "ARN da CMK do KMS para criptografia SSE-KMS (opcional; se não informado, será usada a chave gerenciada AWS/ S3)."
  type        = string
  default     = null
}

variable "logging_target_bucket" {
  description = "Bucket de destino para access logs (opcional). Se definido, habilita logging."
  type        = string
  default     = null
}

variable "logging_target_prefix" {
  description = "Prefixo para os access logs no bucket de destino (opcional)."
  type        = string
  default     = null
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

variable "tags" {
  description = "Mapa de tags a serem aplicadas aos recursos."
  type        = map(string)
  default     = {}
}
