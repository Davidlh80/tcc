variable "aws_region" {
  description = "Regiao AWS onde os recursos serao criados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "aws_region deve seguir o padrao ex: us-east-1."
  }
}

variable "bucket_name" {
  description = "Nome do bucket S3 (deve ser globalmente unico, 3-63 chars, minusculas, numeros, hifens e pontos)."
  type        = string

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63 && can(regex("^[a-z0-9][a-z0-9.-]+[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name deve ter 3-63 caracteres e conter apenas letras minusculas, numeros, hifens e pontos, iniciando e terminando com alfanumerico."
  }

  validation {
    condition     = length(regexall("^\\d+\\.\\d+\\.\\d+\\.\\d+$", var.bucket_name)) == 0
    error_message = "bucket_name nao pode ser semelhante a um endereco IP (ex: 192.168.0.1)."
  }
}

variable "force_destroy" {
  description = "Se true, permite a destruicao do bucket mesmo quando ha objetos (cuidado ao usar)."
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Habilita o versionamento do bucket S3."
  type        = bool
  default     = true
}

variable "object_lock_enabled" {
  description = "Habilita Object Lock no bucket (requer versionamento e so pode ser definido na criacao)."
  type        = bool
  default     = false
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia do lado do servidor: AES256 (SSE-S3) ou aws:kms (SSE-KMS)."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser AES256 ou aws:kms."
  }
}

variable "kms_key_id" {
  description = "ID/ARN da CMK do KMS quando sse_algorithm = aws:kms."
  type        = string
  default     = null

  validation {
    condition     = var.sse_algorithm == "aws:kms" ? (var.kms_key_id != null && trim(var.kms_key_id) != "") : true
    error_message = "kms_key_id deve ser informado quando sse_algorithm = aws:kms."
  }
}

variable "bucket_key_enabled" {
  description = "Habilita S3 Bucket Keys para SSE-KMS (reduz custo e uso do KMS)."
  type        = bool
  default     = true
}

variable "lifecycle_enabled" {
  description = "Habilita regra padrao de ciclo de vida no bucket."
  type        = bool
  default     = true
}

variable "abort_incomplete_multipart_upload_days" {
  description = "Dias para abortar uploads multipart incompletos (0 desabilita)."
  type        = number
  default     = 7

  validation {
    condition     = var.abort_incomplete_multipart_upload_days >= 0
    error_message = "abort_incomplete_multipart_upload_days deve ser >= 0."
  }
}

variable "noncurrent_version_expiration_days" {
  description = "Dias para expirar versoes nao correntes (0 desabilita)."
  type        = number
  default     = 180

  validation {
    condition     = var.noncurrent_version_expiration_days >= 0
    error_message = "noncurrent_version_expiration_days deve ser >= 0."
  }
}

variable "expiration_days" {
  description = "Dias para expirar objetos atuais (0 ou null desabilita)."
  type        = number
  default     = 0

  validation {
    condition     = var.expiration_days >= 0
    error_message = "expiration_days deve ser >= 0."
  }
}

variable "tags" {
  description = "Mapa de tags a serem aplicadas a todos os recursos suportados."
  type        = map(string)
  default     = {}
}
