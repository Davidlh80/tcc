variable "aws_region" {
  description = "Regiao AWS onde o bucket S3 sera provisionado."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome globalmente unico do bucket S3 (minusculas, numeros, pontos e hifens, 3 a 63 caracteres)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usar apenas letras minusculas, numeros, pontos e hifens, e nao pode iniciar ou terminar com ponto ou hifen."
  }
}

variable "versioning_enabled" {
  description = "Define se o versionamento do bucket S3 deve ser habilitado (Enabled) ou suspenso (Suspended)."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite a exclusao do bucket mesmo que ele contenha objetos. Deve ser mantido como false em ambientes produtivos."
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Se vazio, utiliza criptografia padrao AES256 (SSE-S3)."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Mapa de tags adicionais a serem aplicadas ao bucket S3."
  type        = map(string)
  default     = {}
}
