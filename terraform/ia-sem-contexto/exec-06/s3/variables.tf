variable "aws_region" {
  description = "Regiao AWS onde o bucket sera provisionado."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome globalmente unico do bucket S3."
  type        = string

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres."
  }
}

variable "environment" {
  description = "Nome do ambiente (ex.: dev, staging, prod) usado para tagging."
  type        = string
  default     = "dev"
}

variable "enable_versioning" {
  description = "Habilita o versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia server-side padrao do bucket."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser \"AES256\" ou \"aws:kms\"."
  }
}

variable "kms_key_arn" {
  description = "ARN da chave KMS usada para criptografia quando sse_algorithm for \"aws:kms\"."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo que contenha objetos. Deve ser usado com cautela."
  type        = bool
  default     = false
}

variable "block_public_access" {
  description = "Bloqueia todo acesso publico ao bucket (ACLs e politicas)."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags adicionais aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
