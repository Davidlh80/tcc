variable "bucket_name" {
  description = "Nome globalmente unico do bucket S3."
  type        = string
}

variable "versioning_enabled" {
  description = "Define se o versionamento de objetos do bucket deve ser habilitado."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite que o bucket seja destruido mesmo contendo objetos. Use com cautela."
  type        = bool
  default     = false
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia server-side padrao do bucket. Valores aceitos: AES256 ou aws:kms."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser \"AES256\" ou \"aws:kms\"."
  }
}

variable "kms_master_key_id" {
  description = "ARN ou ID da chave KMS usada para criptografia quando sse_algorithm = \"aws:kms\". Ignorado para AES256."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
