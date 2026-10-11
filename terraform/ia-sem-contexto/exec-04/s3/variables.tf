variable "bucket_name" {
  description = "Nome do bucket S3. Deve ser globalmente unico e seguir as regras de nomenclatura da AWS."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usando apenas letras minusculas, numeros, pontos e hifens."
  }
}

variable "enable_versioning" {
  description = "Define se o versionamento de objetos do bucket deve ser habilitado."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Se nao informado, usa criptografia padrao AES256 (SSE-S3)."
  type        = string
  default     = null
}

variable "tags" {
  description = "Mapa de tags adicionais a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
