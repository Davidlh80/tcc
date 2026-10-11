variable "aws_region" {
  description = "Regiao AWS onde o bucket S3 sera criado."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome globalmente unico do bucket S3."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usar apenas letras minusculas, numeros, pontos e hifens, e nao pode iniciar ou terminar com hifen ou ponto."
  }
}

variable "environment" {
  description = "Nome do ambiente (ex.: dev, staging, prod), usado para tagueamento."
  type        = string
  default     = "dev"
}

variable "enable_versioning" {
  description = "Define se o versionamento do bucket S3 deve ser habilitado (Enabled) ou suspenso (Suspended)."
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia server-side padrao do bucket. Valores aceitos: AES256 ou aws:kms."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "O valor de sse_algorithm deve ser 'AES256' ou 'aws:kms'."
  }
}

variable "kms_key_arn" {
  description = "ARN da chave KMS usada para criptografia quando sse_algorithm for 'aws:kms'. Ignorado quando sse_algorithm for 'AES256'."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Permite que o bucket seja destruido mesmo que contenha objetos. Use com cautela."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Mapa de tags adicionais a serem aplicadas ao bucket, mescladas com as tags padrao."
  type        = map(string)
  default     = {}
}
