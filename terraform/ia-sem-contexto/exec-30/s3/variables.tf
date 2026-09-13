variable "region" {
  description = "Regiao AWS onde o bucket sera criado"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome globalmente unico do bucket S3"
  type        = string
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo que contenha objetos"
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Habilita versionamento de objetos no bucket"
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN da chave KMS para criptografia SSE-KMS. Se nulo, usa SSE-S3 (AES256)"
  type        = string
  default     = null
}

variable "enable_lifecycle_rule" {
  description = "Habilita regra de ciclo de vida para expirar versoes antigas e abortar uploads incompletos"
  type        = bool
  default     = true
}

variable "noncurrent_version_expiration_days" {
  description = "Dias para expirar versoes nao atuais de objetos"
  type        = number
  default     = 90
}

variable "tags" {
  description = "Tags adicionais aplicadas ao bucket"
  type        = map(string)
  default     = {}
}
