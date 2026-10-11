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
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usando apenas letras minusculas, numeros, pontos e hifens, iniciando e terminando com letra ou numero."
  }
}

variable "versioning_enabled" {
  description = "Define se o versionamento do bucket S3 esta habilitado (Enabled) ou suspenso (Suspended)."
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

variable "kms_key_id" {
  description = "ARN ou ID da chave KMS usada para criptografia quando sse_algorithm for 'aws:kms'. Ignorado quando sse_algorithm for 'AES256'."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Permite excluir o bucket mesmo que contenha objetos. Mantenha false em ambientes produtivos."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Mapa de tags adicionais aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
