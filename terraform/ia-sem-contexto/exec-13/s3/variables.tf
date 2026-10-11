variable "bucket_name" {
  description = "Nome globalmente unico do bucket S3."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usando apenas letras minusculas, numeros, pontos e hifens, comecando e terminando com letra ou numero."
  }
}

variable "aws_region" {
  description = "Regiao AWS onde o bucket sera criado."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Nome do ambiente (ex: dev, staging, prod) usado para tagueamento."
  type        = string
  default     = "dev"
}

variable "versioning_enabled" {
  description = "Habilita o versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Se nulo, o bucket usa criptografia SSE-S3 (AES256) por padrao."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao bucket, mescladas com as tags padrao."
  type        = map(string)
  default     = {}
}
