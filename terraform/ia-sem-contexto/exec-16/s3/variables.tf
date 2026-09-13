variable "bucket_name" {
  description = "Nome globalmente unico do bucket S3."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usar apenas letras minusculas, numeros, pontos e hifens, e comecar/terminar com letra ou numero."
  }
}

variable "force_destroy" {
  description = "Permite excluir o bucket mesmo que contenha objetos. Use com cautela."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Habilita o versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Se vazio, usa AES256 (SSE-S3)."
  type        = string
  default     = ""
}

variable "enable_lifecycle_rule" {
  description = "Habilita regra de ciclo de vida para expirar versoes antigas e abortar uploads multipart incompletos."
  type        = bool
  default     = true
}

variable "noncurrent_version_expiration_days" {
  description = "Numero de dias apos os quais versoes nao-atuais de objetos sao expiradas."
  type        = number
  default     = 90

  validation {
    condition     = var.noncurrent_version_expiration_days > 0
    error_message = "O valor deve ser um numero positivo de dias."
  }
}

variable "tags" {
  description = "Mapa de tags adicionais a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
