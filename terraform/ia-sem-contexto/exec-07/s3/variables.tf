variable "aws_region" {
  type        = string
  description = "Regiao AWS onde o bucket sera provisionado."
  default     = "us-east-1"
}

variable "bucket_name" {
  type        = string
  description = "Nome globalmente unico do bucket S3."

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usando apenas letras minusculas, numeros, pontos e hifens, comecando e terminando com letra ou numero."
  }
}

variable "force_destroy" {
  type        = bool
  description = "Permite destruir o bucket mesmo que contenha objetos. Recomendado manter false em producao."
  default     = false
}

variable "versioning_enabled" {
  type        = bool
  description = "Habilita o versionamento de objetos no bucket."
  default     = true
}

variable "kms_key_arn" {
  type        = string
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Se nulo, sera usada criptografia AES256 gerenciada pelo S3."
  default     = null
}

variable "enable_lifecycle_rule" {
  type        = bool
  description = "Habilita regra de ciclo de vida para expirar versoes nao atuais dos objetos."
  default     = false
}

variable "noncurrent_version_expiration_days" {
  type        = number
  description = "Numero de dias apos os quais versoes nao atuais dos objetos sao expiradas, quando enable_lifecycle_rule for true."
  default     = 90

  validation {
    condition     = var.noncurrent_version_expiration_days > 0
    error_message = "noncurrent_version_expiration_days deve ser maior que zero."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais a serem aplicadas ao bucket."
  default     = {}
}
