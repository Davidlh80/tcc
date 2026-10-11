variable "bucket_name" {
  description = "Nome globalmente unico do bucket S3."
  type        = string

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres."
  }
}

variable "versioning_enabled" {
  description = "Habilita o versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia server-side padrao do bucket (AES256 ou aws:kms)."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser \"AES256\" ou \"aws:kms\"."
  }
}

variable "kms_key_arn" {
  description = "ARN da chave KMS usada na criptografia quando sse_algorithm for \"aws:kms\". Ignorado caso contrario."
  type        = string
  default     = null
}

variable "tags" {
  description = "Mapa de tags aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
