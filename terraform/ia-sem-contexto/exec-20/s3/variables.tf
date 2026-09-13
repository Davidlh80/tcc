variable "aws_region" {
  description = "Regiao AWS onde o bucket S3 sera provisionado."
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

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo que contenha objetos. Use com cautela."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Habilita o versionamento de objetos no bucket S3."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Se nao informado, utiliza SSE-S3 (AES256)."
  type        = string
  default     = null
}

variable "enable_lifecycle_rule" {
  description = "Habilita regra de lifecycle para abortar uploads multipart incompletos."
  type        = bool
  default     = true
}

variable "abort_incomplete_multipart_upload_days" {
  description = "Numero de dias apos os quais uploads multipart incompletos sao abortados."
  type        = number
  default     = 7
}

variable "tags" {
  description = "Mapa de tags adicionais a serem aplicadas ao bucket S3."
  type        = map(string)
  default     = {}
}
