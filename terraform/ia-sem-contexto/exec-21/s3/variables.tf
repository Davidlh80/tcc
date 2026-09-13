variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome globalmente unico do bucket S3."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usar apenas letras minusculas, numeros, pontos e hifens, e comecar/terminar com letra ou numero."
  }
}

variable "enable_versioning" {
  description = "Habilita o versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite a exclusao do bucket mesmo que contenha objetos. Use com cautela em ambientes produtivos."
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Quando nulo, o bucket usa criptografia SSE-S3 (AES256)."
  type        = string
  default     = null
}

variable "tags" {
  description = "Mapa de tags adicionais aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
