variable "bucket_name" {
  description = "Nome globalmente unico do bucket S3."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres e conter apenas letras minusculas, numeros, pontos e hifens."
  }
}

variable "environment" {
  description = "Ambiente ao qual o bucket pertence (ex.: dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "force_destroy" {
  description = "Permite excluir o bucket mesmo que contenha objetos. Use com cautela."
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Habilita o versionamento de objetos no bucket."
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
  description = "ARN da chave KMS usada para criptografia quando sse_algorithm for 'aws:kms'. Ignorado para AES256."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags adicionais aplicadas ao bucket, mescladas com as tags padrao."
  type        = map(string)
  default     = {}
}
