variable "aws_region" {
  description = "Regiao AWS onde o bucket S3 sera provisionado."
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
  description = "Nome do ambiente (ex: dev, staging, prod) usado para tagueamento."
  type        = string
  default     = "dev"
}

variable "versioning_enabled" {
  description = "Define se o versionamento de objetos do bucket esta habilitado."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite a exclusao do bucket mesmo que ele contenha objetos. Use com cautela."
  type        = bool
  default     = false
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia do lado do servidor aplicado por padrao ao bucket. Valores aceitos: AES256 ou aws:kms."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser 'AES256' ou 'aws:kms'."
  }
}

variable "kms_master_key_arn" {
  description = "ARN da chave KMS usada para criptografia quando sse_algorithm for 'aws:kms'. Ignorado para AES256."
  type        = string
  default     = null
}

variable "tags" {
  description = "Mapa de tags adicionais a serem aplicadas ao bucket, mescladas com as tags padrao."
  type        = map(string)
  default     = {}
}
