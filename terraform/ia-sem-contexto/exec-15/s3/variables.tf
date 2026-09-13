variable "aws_region" {
  description = "Regiao AWS onde o bucket sera criado."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome globalmente unico do bucket S3."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres e conter apenas letras minusculas, numeros, pontos e hifens."
  }
}

variable "versioning_enabled" {
  description = "Habilita versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Se nulo, usa criptografia AES256 gerenciada pela AWS."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo que contenha objetos. Recomendado manter false em producao."
  type        = bool
  default     = false
}

variable "enable_lifecycle_rule" {
  description = "Habilita regra de ciclo de vida para expirar versoes antigas de objetos."
  type        = bool
  default     = true
}

variable "noncurrent_version_expiration_days" {
  description = "Numero de dias apos os quais versoes antigas (nao atuais) de objetos sao expiradas."
  type        = number
  default     = 90

  validation {
    condition     = var.noncurrent_version_expiration_days > 0
    error_message = "O valor deve ser um numero positivo de dias."
  }
}

variable "tags" {
  description = "Mapa de tags a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
