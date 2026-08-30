variable "aws_region" {
  description = "Região AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(var.aws_region) > 0
    error_message = "A região AWS (aws_region) não pode ser vazia."
  }
}

variable "environment" {
  description = "Ambiente alvo (dev, hml, prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O ambiente deve ser um dos valores permitidos: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou aplicação (minúsculo, números e hífens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "O campo 'system' deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "bucket_purpose" {
  description = "Finalidade do bucket (minúsculo, números e hífens). Ex.: logs, artifacts, backups."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.bucket_purpose)) && length(var.bucket_purpose) > 0
    error_message = "O campo 'bucket_purpose' deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "name_suffix" {
  description = "Sufixo opcional para auxiliar na unicidade global do nome do bucket (minúsculo, números e hífens)."
  type        = string
  default     = ""

  validation {
    condition     = var.name_suffix == "" || can(regex("^[a-z0-9-]+$", var.name_suffix))
    error_message = "O campo 'name_suffix', quando informado, deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "versioning_enabled" {
  description = "Habilita o versionamento do bucket S3."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo se ele contiver objetos. Use com cautela."
  type        = bool
  default     = false
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia server-side (AES256 ou aws:kms)."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser 'AES256' ou 'aws:kms'."
  }
}

variable "kms_key_arn" {
  description = "ARN da CMK para criptografia quando sse_algorithm = 'aws:kms'."
  type        = string
  default     = ""

  validation {
    condition     = var.sse_algorithm != "aws:kms" || (length(var.kms_key_arn) > 0 && can(regex("^arn:aws(-[a-z]+)?:kms:[a-z0-9-]+:\\d{12}:key\\/[a-f0-9-]+$", var.kms_key_arn)))
    error_message = "Quando sse_algorithm for 'aws:kms', kms_key_arn deve ser um ARN válido de chave KMS."
  }
}

variable "enable_bucket_key" {
  description = "Habilita S3 Bucket Keys (recomendado quando usando KMS para reduzir custo de requisições KMS). Somente efetivo com aws:kms."
  type        = bool
  default     = true
}

variable "additional_tags" {
  description = "Mapa de tags adicionais a serem aplicadas aos recursos suportados."
  type        = map(string)
  default     = {}
}
