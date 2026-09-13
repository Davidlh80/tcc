variable "bucket_name" {
  description = "Nome globalmente unico do bucket S3."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres e conter apenas letras minusculas, numeros, pontos e hifens."
  }
}

variable "force_destroy" {
  description = "Permite exclusao do bucket mesmo se contiver objetos. Use com cautela."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Habilita versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Se nulo, usa AES256 (SSE-S3)."
  type        = string
  default     = null
}

variable "enable_lifecycle_rule" {
  description = "Habilita regra de ciclo de vida para expirar versoes antigas e abortar multipart uploads incompletos."
  type        = bool
  default     = true
}

variable "noncurrent_version_expiration_days" {
  description = "Numero de dias apos os quais versoes nao-atuais de objetos sao expiradas."
  type        = number
  default     = 90

  validation {
    condition     = var.noncurrent_version_expiration_days > 0
    error_message = "O valor deve ser maior que zero."
  }
}

variable "logging_target_bucket" {
  description = "Nome do bucket de destino para logs de acesso do S3. Se nulo, logging nao e habilitado."
  type        = string
  default     = null
}

variable "logging_target_prefix" {
  description = "Prefixo aplicado aos logs de acesso enviados ao bucket de destino."
  type        = string
  default     = "s3-access-logs/"
}

variable "tags" {
  description = "Mapa de tags aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
