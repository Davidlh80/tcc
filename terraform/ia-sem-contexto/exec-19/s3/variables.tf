variable "aws_region" {
  description = "AWS region onde os recursos serao criados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z0-9-]+-\\d$", var.aws_region))
    error_message = "aws_region deve ser um nome de regiao valido, por exemplo: us-east-1."
  }
}

variable "bucket_name" {
  description = "Nome do bucket S3 (deve ser globalmente unico)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name deve ter entre 3 e 63 caracteres, conter apenas letras minusculas, numeros, hifens ou pontos e iniciar/terminar com letra ou numero."
  }
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo se houver objetos (use com cautela)."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Habilita versionamento do bucket."
  type        = bool
  default     = true
}

variable "enable_lifecycle" {
  description = "Habilita regras de ciclo de vida padrao (limpeza de partes incompletas e de versoes antigas)."
  type        = bool
  default     = true
}

variable "lifecycle_abort_incomplete_upload_days" {
  description = "Dias para abortar uploads multipart incompletos."
  type        = number
  default     = 7

  validation {
    condition     = var.lifecycle_abort_incomplete_upload_days >= 1 && var.lifecycle_abort_incomplete_upload_days <= 365
    error_message = "lifecycle_abort_incomplete_upload_days deve estar entre 1 e 365."
  }
}

variable "lifecycle_noncurrent_expiration_days" {
  description = "Dias para expirar versoes nao correntes de objetos."
  type        = number
  default     = 30

  validation {
    condition     = var.lifecycle_noncurrent_expiration_days >= 1
    error_message = "lifecycle_noncurrent_expiration_days deve ser >= 1."
  }
}

variable "enforce_tls" {
  description = "Cria uma policy que nega acesso ao bucket via HTTP (somente HTTPS/TLS)."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Mapa de tags adicionais a aplicar em todos os recursos."
  type        = map(string)
  default     = {}
}
