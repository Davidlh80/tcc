variable "aws_region" {
  description = "Região AWS onde o bucket será provisionado."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome globalmente único do bucket S3."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve seguir as regras de nomenclatura do S3: minúsculas, números, pontos e hifens, entre 3 e 63 caracteres."
  }
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo contendo objetos. Use com cautela."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Habilita o versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Se não informado, usa AES256 (SSE-S3)."
  type        = string
  default     = null
}

variable "enable_lifecycle_rule" {
  description = "Habilita regra de ciclo de vida para expirar versões não atuais."
  type        = bool
  default     = true
}

variable "noncurrent_version_expiration_days" {
  description = "Número de dias para expirar versões não atuais dos objetos."
  type        = number
  default     = 90
}

variable "tags" {
  description = "Mapa de tags a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
