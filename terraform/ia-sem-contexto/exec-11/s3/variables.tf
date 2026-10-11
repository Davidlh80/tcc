variable "bucket_name" {
  type        = string
  description = "Nome globalmente unico do bucket S3."

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usando apenas letras minusculas, numeros, pontos e hifens, e nao pode iniciar ou terminar com hifen ou ponto."
  }
}

variable "environment" {
  type        = string
  description = "Nome do ambiente (ex.: dev, staging, prod), usado para tagueamento."
  default     = "dev"
}

variable "versioning_enabled" {
  type        = bool
  description = "Habilita (true) ou suspende (false) o versionamento do bucket."
  default     = true
}

variable "kms_key_arn" {
  type        = string
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Se nulo, usa criptografia SSE-S3 (AES256)."
  default     = null
}

variable "force_destroy" {
  type        = bool
  description = "Permite que o bucket seja destruido mesmo contendo objetos. Use com cautela."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais aplicadas ao bucket, mescladas com as tags padrao."
  default     = {}
}
