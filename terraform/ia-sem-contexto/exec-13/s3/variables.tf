variable "aws_region" {
  description = "Região AWS onde o bucket será provisionado."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome globalmente único do bucket S3."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve seguir as regras de nomenclatura da AWS S3 (minúsculas, números, pontos e hifens, 3 a 63 caracteres)."
  }
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo que contenha objetos. Use com cautela."
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Habilita versionamento no bucket."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Se nulo, usa AES256 (SSE-S3)."
  type        = string
  default     = null
}

variable "enable_lifecycle_rule" {
  description = "Habilita regra de ciclo de vida para expirar versões não atuais."
  type        = bool
  default     = true
}

variable "noncurrent_version_expiration_days" {
  description = "Dias até a expiração de versões não atuais dos objetos."
  type        = number
  default     = 90
}

variable "logging_target_bucket" {
  description = "Nome do bucket de destino para logs de acesso. Se nulo, logging não é habilitado."
  type        = string
  default     = null
}

variable "logging_target_prefix" {
  description = "Prefixo aplicado aos objetos de log de acesso."
  type        = string
  default     = "log/"
}

variable "tags" {
  description = "Tags adicionais aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
