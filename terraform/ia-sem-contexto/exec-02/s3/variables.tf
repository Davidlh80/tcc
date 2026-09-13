variable "bucket_name" {
  description = "Nome global do bucket S3 (deve ser unico em toda a AWS)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usar apenas letras minusculas, numeros, pontos e hifens, e nao pode iniciar ou terminar com ponto ou hifen."
  }
}

variable "aws_region" {
  description = "Regiao AWS onde o bucket sera criado."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Nome do ambiente (ex.: dev, staging, prod), usado para tagging."
  type        = string
  default     = "dev"
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo que contenha objetos. Use com cautela em ambientes produtivos."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Habilita o versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Se nao informado (null), o bucket usa criptografia SSE-S3 (AES256)."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao bucket, alem das tags padrao (Name e Environment)."
  type        = map(string)
  default     = {}
}
