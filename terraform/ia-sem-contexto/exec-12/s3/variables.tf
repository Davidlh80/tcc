variable "aws_region" {
  description = "Região AWS onde o bucket S3 será provisionado."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome globalmente único do bucket S3 (minúsculas, números, pontos e hífens; 3 a 63 caracteres)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.bucket_name))
    error_message = "bucket_name deve conter apenas letras minúsculas, números, pontos e hífens, com 3 a 63 caracteres."
  }
}

variable "environment" {
  description = "Nome do ambiente (ex.: dev, staging, prod), usado em tags."
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo que contenha objetos. Recomendado manter false em produção."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Habilita o versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "block_public_access" {
  description = "Bloqueia todo acesso público ao bucket (ACLs e políticas públicas). Recomendado manter true."
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia server-side padrão do bucket: AES256 ou aws:kms."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser 'AES256' ou 'aws:kms'."
  }
}

variable "kms_key_arn" {
  description = "ARN da chave KMS usada para criptografia quando sse_algorithm for 'aws:kms'. Ignorado caso contrário."
  type        = string
  default     = null
}
