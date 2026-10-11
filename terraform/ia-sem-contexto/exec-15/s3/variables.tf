variable "bucket_name" {
  description = "Nome globalmente unico do bucket S3."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usar apenas letras minusculas, numeros, pontos e hifens, e nao pode iniciar ou terminar com ponto ou hifen."
  }
}

variable "environment" {
  description = "Nome do ambiente (ex.: dev, staging, prod), usado para fins de tagueamento."
  type        = string
  default     = "dev"
}

variable "versioning_enabled" {
  description = "Define se o versionamento do bucket S3 deve ser habilitado (Enabled) ou suspenso (Suspended)."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS customer-managed para criptografia SSE-KMS. Quando nulo, utiliza criptografia AES256 padrao do S3 (SSE-S3)."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Permite que o bucket seja destruido mesmo contendo objetos. Mantenha false em ambientes produtivos."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Mapa de tags adicionais a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
