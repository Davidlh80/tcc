variable "bucket_name" {
  description = "Nome globalmente unico do bucket S3."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usar apenas letras minusculas, numeros, pontos ou hifens, e comecar/terminar com letra ou numero."
  }
}

variable "force_destroy" {
  description = "Permite excluir o bucket mesmo que contenha objetos. Use com cautela."
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Habilita versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Se vazio, usa AES256 (SSE-S3)."
  type        = string
  default     = ""
}

variable "lifecycle_expiration_days" {
  description = "Numero de dias para expirar versoes nao atuais dos objetos. Defina 0 para desabilitar a regra de lifecycle."
  type        = number
  default     = 90

  validation {
    condition     = var.lifecycle_expiration_days >= 0
    error_message = "O valor de lifecycle_expiration_days deve ser maior ou igual a 0."
  }
}

variable "enforce_tls" {
  description = "Adiciona uma bucket policy que nega requisicoes que nao usem TLS (HTTPS)."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Mapa de tags a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
