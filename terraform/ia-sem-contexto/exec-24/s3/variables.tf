variable "bucket_name" {
  description = "Nome do bucket S3 a ser criado. Deve ser globalmente unico."
  type        = string

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres."
  }
}

variable "versioning_enabled" {
  description = "Define se o versionamento do bucket deve ser habilitado (true) ou suspenso (false)."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite que o bucket seja destruido mesmo contendo objetos. Use com cautela."
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Se nulo, usa criptografia SSE-S3 (AES256)."
  type        = string
  default     = null
}

variable "tags" {
  description = "Mapa de tags a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
