variable "bucket_name" {
  description = "Nome globalmente unico do bucket S3 (3 a 63 caracteres, letras minusculas, numeros, pontos e hifens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, conter apenas letras minusculas, numeros, pontos e hifens, e comecar/terminar com letra ou numero."
  }
}

variable "region" {
  description = "Regiao AWS onde o bucket sera provisionado."
  type        = string
  default     = "us-east-1"
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo que ele contenha objetos. Use com cautela."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Habilita o versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Se vazio, utiliza SSE-S3 (AES256)."
  type        = string
  default     = ""
}

variable "noncurrent_version_expiration_days" {
  description = "Numero de dias para expirar versoes nao atuais de objetos. Defina 0 para desabilitar a regra de ciclo de vida."
  type        = number
  default     = 90
}

variable "tags" {
  description = "Mapa de tags a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
