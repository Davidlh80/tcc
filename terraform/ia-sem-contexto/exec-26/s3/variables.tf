variable "bucket_name" {
  description = "Nome globalmente unico do bucket S3."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usar apenas letras minusculas, numeros, pontos e hifens, e comecar/terminar com letra ou numero."
  }
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo que ele contenha objetos."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Habilita versionamento de objetos no bucket."
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
  description = "ARN da chave KMS usada para criptografia quando sse_algorithm for \"aws:kms\". Deixe null para usar a chave gerenciada pela AWS (aws/s3)."
  type        = string
  default     = null
}

variable "block_public_access" {
  description = "Bloqueia acesso publico ao bucket em todas as dimensoes (ACLs e politicas)."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
