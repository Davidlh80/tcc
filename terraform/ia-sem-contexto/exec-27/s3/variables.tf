variable "bucket_name" {
  type        = string
  description = "Nome globalmente unico do bucket S3."

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usar apenas letras minusculas, numeros, pontos e hifens, e comecar/terminar com letra ou numero."
  }
}

variable "aws_region" {
  type        = string
  description = "Regiao AWS onde o bucket sera criado."
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Nome do ambiente (ex: dev, staging, prod), usado apenas para tagging."
  default     = "dev"
}

variable "enable_versioning" {
  type        = bool
  description = "Habilita o versionamento de objetos no bucket."
  default     = true
}

variable "sse_algorithm" {
  type        = string
  description = "Algoritmo de criptografia server-side padrao do bucket (AES256 ou aws:kms)."
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "O valor de sse_algorithm deve ser 'AES256' ou 'aws:kms'."
  }
}

variable "kms_key_arn" {
  type        = string
  description = "ARN da chave KMS usada para criptografia quando sse_algorithm for 'aws:kms'. Ignorado caso contrario."
  default     = null
  nullable    = true
}

variable "force_destroy" {
  type        = bool
  description = "Permite excluir o bucket mesmo que contenha objetos. Use com cautela."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais aplicadas ao bucket."
  default     = {}
}
