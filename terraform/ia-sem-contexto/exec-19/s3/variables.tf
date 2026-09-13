variable "bucket_name" {
  description = "Nome globalmente unico do bucket S3."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, apenas letras minusculas, numeros, pontos e hifens, iniciando e terminando com letra ou numero."
  }
}

variable "force_destroy" {
  description = "Permite exclusao do bucket mesmo que contenha objetos. Use com cautela."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Habilita versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Se nulo, usa SSE-S3 (AES256)."
  type        = string
  default     = null
}

variable "enable_lifecycle_rule" {
  description = "Habilita regra de ciclo de vida para expirar versoes antigas de objetos."
  type        = bool
  default     = true
}

variable "noncurrent_version_expiration_days" {
  description = "Numero de dias apos os quais versoes nao atuais de objetos sao expiradas."
  type        = number
  default     = 90
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
