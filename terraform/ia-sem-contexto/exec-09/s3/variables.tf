variable "bucket_name" {
  description = "Nome globalmente unico do bucket S3."
  type        = string
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo que contenha objetos."
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Habilita versionamento no bucket S3."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Se nulo, usa AES256 (SSE-S3)."
  type        = string
  default     = null
}

variable "enable_lifecycle_rule" {
  description = "Habilita regra de ciclo de vida para expirar versoes nao-atuais."
  type        = bool
  default     = true
}

variable "noncurrent_version_expiration_days" {
  description = "Numero de dias apos os quais versoes nao-atuais dos objetos sao expiradas."
  type        = number
  default     = 90
}

variable "tags" {
  description = "Mapa de tags a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
