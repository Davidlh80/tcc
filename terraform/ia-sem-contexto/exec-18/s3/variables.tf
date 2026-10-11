variable "bucket_name" {
  description = "Nome globalmente unico do bucket S3."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usando apenas letras minusculas, numeros, pontos e hifens, iniciando e terminando com letra ou numero."
  }
}

variable "environment" {
  description = "Nome do ambiente (ex: dev, staging, prod), usado para tagueamento."
  type        = string
  default     = "dev"
}

variable "versioning_enabled" {
  description = "Habilita o versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo que contenha objetos. Use com cautela."
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Se nulo, usa criptografia AES256 gerenciada pelo S3."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
