variable "aws_region" {
  description = "Regiao AWS onde o bucket S3 sera provisionado."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome globalmente unico do bucket S3."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usando apenas letras minusculas, numeros, pontos e hifens, iniciando e terminando com letra ou numero."
  }
}

variable "environment" {
  description = "Nome do ambiente (ex.: dev, staging, prod), usado para tagging."
  type        = string
  default     = "dev"
}

variable "enable_versioning" {
  description = "Define se o versionamento do bucket S3 deve ser habilitado."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Se nao informado, sera usado AES256 (SSE-S3)."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Permite que o bucket seja destruido mesmo contendo objetos. Mantenha false em producao."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao bucket, mescladas com as tags padrao."
  type        = map(string)
  default     = {}
}
