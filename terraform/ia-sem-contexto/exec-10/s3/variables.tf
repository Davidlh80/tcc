variable "aws_region" {
  description = "Regiao AWS onde o bucket sera provisionado."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome globalmente unico do bucket S3, seguindo as regras de nomenclatura da AWS."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usar apenas letras minusculas, numeros, pontos e hifens, e comecar/terminar com letra ou numero."
  }
}

variable "environment" {
  description = "Ambiente ao qual o bucket pertence (dev, staging ou prod)."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "O valor de environment deve ser 'dev', 'staging' ou 'prod'."
  }
}

variable "enable_versioning" {
  description = "Habilita o versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo que ele contenha objetos. Deve ser mantido como false em producao."
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Se nao informado, o bucket usa criptografia SSE-S3 (AES256) por padrao."
  type        = string
  default     = null
}

variable "tags" {
  description = "Mapa de tags a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
