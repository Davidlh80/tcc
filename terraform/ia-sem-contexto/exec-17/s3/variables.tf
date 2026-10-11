variable "region" {
  description = "Regiao AWS onde o bucket S3 sera criado."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome globalmente unico do bucket S3."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve seguir as regras de nomenclatura da AWS (letras minusculas, numeros, pontos e hifens, entre 3 e 63 caracteres)."
  }
}

variable "environment" {
  description = "Nome do ambiente (ex: dev, staging, prod), usado para tagueamento."
  type        = string
  default     = "dev"
}

variable "enable_versioning" {
  description = "Define se o versionamento de objetos do bucket estara habilitado."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo que contenha objetos. Use com cautela."
  type        = bool
  default     = false
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia do lado do servidor aplicado por padrao aos objetos."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser 'AES256' ou 'aws:kms'."
  }
}

variable "kms_key_arn" {
  description = "ARN da chave KMS usada para criptografia quando sse_algorithm for 'aws:kms'. Deixe nulo para usar a chave gerenciada pela AWS (aws/s3)."
  type        = string
  default     = null
}

variable "bucket_key_enabled" {
  description = "Habilita o S3 Bucket Key para reduzir custos de chamadas ao KMS quando sse_algorithm for 'aws:kms'."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao bucket, mescladas com as tags padrao."
  type        = map(string)
  default     = {}
}
