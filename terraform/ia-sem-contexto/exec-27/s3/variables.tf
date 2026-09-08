variable "aws_region" {
  description = "Regiao AWS na qual os recursos serao criados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "aws_region deve estar no formato valido, por exemplo: us-east-1."
  }
}

variable "bucket_name" {
  description = "Nome do bucket S3 (globalmente unico)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name deve ter entre 3 e 63 caracteres, usar apenas letras minusculas, numeros, pontos e hifens, e nao pode começar/terminar com ponto ou hifen."
  }

  validation {
    condition     = !can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+$", var.bucket_name))
    error_message = "bucket_name nao pode ser um endereco IP puro."
  }
}

variable "versioning_enabled" {
  description = "Habilita versionamento no bucket."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo contendo objetos."
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "ARN ou ID da CMK do KMS para criptografia do bucket. Se vazio, usa SSE-S3 (AES256)."
  type        = string
  default     = null
}

variable "abort_incomplete_multipart_days" {
  description = "Dias para abortar uploads multipart incompletos."
  type        = number
  default     = 7

  validation {
    condition     = var.abort_incomplete_multipart_days >= 1 && var.abort_incomplete_multipart_days <= 30
    error_message = "abort_incomplete_multipart_days deve estar entre 1 e 30 dias."
  }
}

variable "attach_https_only_policy" {
  description = "Anexa politica que nega trafego nao-HTTPS para o bucket."
  type        = bool
  default     = true
}

variable "block_public_acls" {
  description = "Bloqueia ACLs publicas no bucket."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Bloqueia politicas publicas no bucket."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignora ACLs publicas no bucket."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restringe acessos publicos ao bucket."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Mapa de tags a serem aplicadas aos recursos."
  type        = map(string)
  default     = {}
}
