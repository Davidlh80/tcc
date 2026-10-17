variable "region" {
  description = "Região AWS onde o bucket será criado."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome globalmente único do bucket S3."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter de 3 a 63 caracteres: letras minúsculas, números, pontos e hífens."
  }
}

variable "environment" {
  description = "Ambiente de implantação (dev, hml ou prod)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prod"], var.environment)
    error_message = "O ambiente deve ser dev, hml ou prod."
  }
}

variable "versioning_enabled" {
  description = "Habilita o versionamento de objetos do bucket."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS gerenciada pelo cliente. Se nulo, usa a chave gerenciada pela AWS (aws/s3)."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags adicionais aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
