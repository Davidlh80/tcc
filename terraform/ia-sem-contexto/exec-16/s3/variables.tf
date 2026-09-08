variable "aws_region" {
  description = "Regiao AWS onde o bucket sera criado."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(var.aws_region) > 0
    error_message = "aws_region nao pode ser vazio."
  }
}

variable "bucket_name" {
  description = "Nome unico global do bucket S3 (3-63 caracteres, letras minusculas, numeros, hifens e pontos)."
  type        = string

  validation {
    condition = can(regex("^(?=.{3,63}$)(?!\\d+\\.\\d+\\.\\d+\\.\\d+$)(?!-)(?!.*--)(?!.*\\.-)(?!.*-\\.)[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name deve ter entre 3 e 63 caracteres, apenas letras minusculas, numeros, pontos e hifens, nao pode ser semelhante a IP e nao pode começar ou terminar com hifen ou ponto."
  }
}

variable "force_destroy" {
  description = "Se true, permite destruir o bucket mesmo com objetos (cuidado em producao)."
  type        = bool
  default     = false
}

variable "bucket_versioning_enabled" {
  description = "Habilita versionamento do bucket."
  type        = bool
  default     = true
}

variable "sse_kms_key_arn" {
  description = "ARN de uma CMK do KMS para criptografia server-side. Se nulo, usa SSE-S3 (AES256)."
  type        = string
  default     = null

  validation {
    condition     = var.sse_kms_key_arn == null || can(regex("^arn:[a-z0-9-]+:kms:[a-z0-9-]*:\\d{12}:key\\/.+", var.sse_kms_key_arn))
    error_message = "sse_kms_key_arn deve ser um ARN valido de chave KMS ou null."
  }
}

variable "sse_bucket_key_enabled" {
  description = "Habilita S3 Bucket Keys para reduzir custos com KMS quando usando SSE-KMS."
  type        = bool
  default     = true
}

variable "abort_incomplete_multipart_upload_days" {
  description = "Dias para abortar uploads multiplas partes incompletos."
  type        = number
  default     = 7

  validation {
    condition     = var.abort_incomplete_multipart_upload_days >= 1 && var.abort_incomplete_multipart_upload_days <= 365
    error_message = "abort_incomplete_multipart_upload_days deve estar entre 1 e 365."
  }
}

variable "logging_enabled" {
  description = "Se true, habilita server access logging do bucket para outro bucket S3."
  type        = bool
  default     = false
}

variable "logging_target_bucket" {
  description = "Bucket de destino para logs de acesso (necessario se logging_enabled = true)."
  type        = string
  default     = ""

  validation {
    condition     = var.logging_enabled == false || length(var.logging_target_bucket) > 0
    error_message = "logging_target_bucket deve ser informado quando logging_enabled = true."
  }
}

variable "logging_target_prefix" {
  description = "Prefixo para objetos de log no bucket de destino."
  type        = string
  default     = "s3-access-logs/"
}

variable "block_public_acls" {
  description = "Bloqueia ACLs publicas."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Bloqueia politicas publicas."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignora ACLs publicas existentes."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restringe buckets publicos a apenas acessos via politicas especificas."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Mapa de tags adicionais para aplicar ao bucket."
  type        = map(string)
  default     = {}
}
