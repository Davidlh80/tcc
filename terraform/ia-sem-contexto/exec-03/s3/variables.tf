variable "aws_region" {
  description = "Região AWS onde o bucket será criado."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome globalmente único do bucket S3."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usando apenas letras minúsculas, números, pontos e hifens, começando e terminando com letra ou número."
  }
}

variable "tags" {
  description = "Mapa de tags adicionais a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}

variable "versioning_enabled" {
  description = "Habilita o versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Se não informado, usa AES256 (SSE-S3)."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo que contenha objetos. Use com cautela."
  type        = bool
  default     = false
}

variable "enable_lifecycle_rule" {
  description = "Habilita regra de ciclo de vida para expiração de objetos e versões antigas."
  type        = bool
  default     = false
}

variable "lifecycle_expiration_days" {
  description = "Número de dias para expiração de objetos e versões não atuais, quando enable_lifecycle_rule é true."
  type        = number
  default     = 365
}
