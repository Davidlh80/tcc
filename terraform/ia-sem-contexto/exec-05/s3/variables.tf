variable "bucket_name" {
  description = "Nome do bucket S3. Deve ser globalmente unico e seguir as regras de nomenclatura da AWS."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usar apenas letras minusculas, numeros, pontos e hifens, e nao pode iniciar ou terminar com hifen ou ponto."
  }
}

variable "versioning_enabled" {
  description = "Habilita o versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Se nulo, o bucket usa criptografia AES256 (SSE-S3) gerenciada pela AWS."
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
