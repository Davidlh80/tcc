variable "aws_region" {
  description = "Região AWS para provisionamento dos recursos."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "A região deve seguir o padrão, por exemplo: us-east-1, sa-east-1."
  }
}

variable "environment" {
  description = "Ambiente de implantação (dev, hml, prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O ambiente deve ser um de: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema conforme padrão interno (somente minúsculas, números e hífens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) >= 2 && length(var.system) <= 30
    error_message = "O nome do sistema deve conter de 2 a 30 caracteres, em minúsculas, com números e hífens."
  }
}

variable "purpose" {
  description = "Finalidade do bucket (parte final do nome; somente minúsculas, números e hífens)."
  type        = string
  default     = "data"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.purpose)) && length(var.purpose) >= 2 && length(var.purpose) <= 30
    error_message = "A finalidade deve conter de 2 a 30 caracteres, em minúsculas, com números e hífens."
  }
}

variable "bucket_name" {
  description = "Nome completo do bucket S3. Se não definido, será construído como <environment>-<system>-s3-<purpose>."
  type        = string
  default     = null

  validation {
    condition     = var.bucket_name == null ? true : can(regex("^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ser minúsculo, entre 3 e 63 caracteres, iniciar e terminar com letra/número e conter apenas letras, números e hífens."
  }
}

variable "enable_versioning" {
  description = "Habilita o versionamento no bucket S3."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo se houver objetos (use com cautela)."
  type        = bool
  default     = false
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia server-side: AES256 (SSE-S3) ou aws:kms (SSE-KMS)."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser um de: AES256, aws:kms."
  }
}

variable "kms_key_id" {
  description = "KMS Key ID ou ARN para SSE-KMS. Necessário se sse_algorithm = aws:kms."
  type        = string
  default     = null
}

variable "enforce_sse_policy" {
  description = "Cria política no bucket para recusar uploads sem a criptografia definida."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags adicionais a serem adicionadas aos recursos."
  type        = map(string)
  default     = {}
}
