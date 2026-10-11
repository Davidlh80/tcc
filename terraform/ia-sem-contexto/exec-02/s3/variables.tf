variable "aws_region" {
  type        = string
  description = "Regiao AWS onde o bucket sera provisionado."
  default     = "us-east-1"
}

variable "bucket_name" {
  type        = string
  description = "Nome globalmente unico do bucket S3."

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres."
  }

  validation {
    condition     = can(regex("^[a-z0-9.-]+$", var.bucket_name))
    error_message = "O nome do bucket deve conter apenas letras minusculas, numeros, pontos e hifens."
  }
}

variable "force_destroy" {
  type        = bool
  description = "Permite destruir o bucket mesmo que contenha objetos. Mantenha false em producao."
  default     = false
}

variable "enable_versioning" {
  type        = bool
  description = "Habilita o versionamento de objetos no bucket."
  default     = true
}

variable "sse_algorithm" {
  type        = string
  description = "Algoritmo de criptografia padrao do bucket. Use AES256 ou aws:kms."
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "O valor de sse_algorithm deve ser AES256 ou aws:kms."
  }
}

variable "kms_key_arn" {
  type        = string
  description = "ARN da chave KMS usada quando sse_algorithm for aws:kms. Ignorado quando AES256."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais aplicadas ao bucket, mescladas com as tags padrao."
  default     = {}
}
