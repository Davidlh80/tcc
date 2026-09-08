variable "aws_region" {
  description = "Regiao AWS onde os recursos serao criados (ex.: us-east-1)."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "aws_region deve estar no formato correto, por exemplo: us-east-1, eu-west-1."
  }
}

variable "bucket_name" {
  description = "Nome globalmente unico do bucket S3."
  type        = string

  validation {
    condition = alltrue([
      can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name)),
      !can(regex("(\\.|^)(-)|(-)(\\.|$)", var.bucket_name)),            # evita '-.' ou '.-'
      !can(regex("\\.\\.", var.bucket_name)),                           # evita '..'
      !can(regex("^(\\d{1,3}\\.){3}\\d{1,3}$", var.bucket_name))        # evita formato de IP
    ])
    error_message = "bucket_name invalido. Deve ter 3-63 caracteres, minusculas, numeros, pontos e hifens; iniciar/terminar com letra/numero; nao pode parecer um IP; sem '..', '-.' ou '.-'."
  }
}

variable "force_destroy" {
  description = "Se true, permite destruir o bucket mesmo contendo objetos."
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Ativa o versionamento do bucket."
  type        = bool
  default     = true
}

variable "noncurrent_version_expiration_days" {
  description = "Dias para expirar versoes nao correntes. Valido apenas quando versionamento esta habilitado (> 0 para habilitar a regra)."
  type        = number
  default     = 90

  validation {
    condition     = var.noncurrent_version_expiration_days >= 0 && var.noncurrent_version_expiration_days <= 3650
    error_message = "noncurrent_version_expiration_days deve estar entre 0 e 3650."
  }
}

variable "abort_incomplete_multipart_upload_days" {
  description = "Dias para abortar uploads multipart incompletos."
  type        = number
  default     = 7

  validation {
    condition     = var.abort_incomplete_multipart_upload_days >= 1 && var.abort_incomplete_multipart_upload_days <= 30
    error_message = "abort_incomplete_multipart_upload_days deve estar entre 1 e 30."
  }
}

variable "enable_public_access_block" {
  description = "Se true, bloqueia qualquer configuracao de acesso publico ao bucket."
  type        = bool
  default     = true
}

variable "attach_tls_enforce_policy" {
  description = "Se true, anexa uma policy que nega qualquer acesso nao-TLS (sem HTTPS)."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Mapa de tags adicionais a aplicar no bucket."
  type        = map(string)
  default     = {}
}
