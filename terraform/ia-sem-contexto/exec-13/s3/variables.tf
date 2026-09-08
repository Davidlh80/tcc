variable "bucket_name" {
  description = "Nome do bucket S3 (3-63 caracteres, minusculas, numeros, pontos e hifens; deve iniciar e terminar com letra ou numero)."
  type        = string

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63 && can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name invalido. Use 3-63 caracteres: [a-z0-9.-], iniciando e terminando com [a-z0-9]."
  }
}

variable "region" {
  description = "Regiao AWS para o provider."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(trim(var.region)) > 0
    error_message = "region nao pode ser vazia."
  }
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo que existam objetos."
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Habilita versionamento no bucket."
  type        = bool
  default     = true
}

variable "object_lock_enabled" {
  description = "Habilita Object Lock no bucket (requer versionamento habilitado; so pode ser definido na criacao)."
  type        = bool
  default     = false

  validation {
    condition     = var.object_lock_enabled ? var.versioning_enabled : true
    error_message = "Para habilitar object_lock_enabled, versioning_enabled deve ser true."
  }
}

variable "abort_multipart_upload_days" {
  description = "Dias para abortar uploads multiparte incompletos."
  type        = number
  default     = 7

  validation {
    condition     = var.abort_multipart_upload_days >= 1 && var.abort_multipart_upload_days <= 365
    error_message = "abort_multipart_upload_days deve estar entre 1 e 365."
  }
}

variable "noncurrent_version_expiration_days" {
  description = "Dias para expirar versoes nao correntes (aplicado somente quando versionamento estiver habilitado)."
  type        = number
  default     = 365

  validation {
    condition     = var.noncurrent_version_expiration_days >= 1
    error_message = "noncurrent_version_expiration_days deve ser >= 1."
  }
}

variable "tags" {
  description = "Mapa de tags adicionais a aplicar aos recursos suportados."
  type        = map(string)
  default     = {}
}
