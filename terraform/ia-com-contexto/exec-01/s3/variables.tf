variable "region" {
  description = "Região AWS onde os recursos serão criados."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d+$", var.region))
    error_message = "A região deve estar no formato válido, por exemplo: us-east-1, sa-east-1, eu-west-1."
  }
}

variable "environment" {
  description = "Ambiente alvo. Deve ser um dos valores permitidos pela organização."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O ambiente deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou aplicação (minúsculo, números e hífens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) >= 2
    error_message = "O sistema deve conter apenas letras minúsculas, números e hífens, com pelo menos 2 caracteres."
  }
}

variable "purpose" {
  description = "Finalidade do bucket (ex.: logs, assets, backups)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.purpose)) && length(var.purpose) >= 3
    error_message = "A finalidade deve conter apenas letras minúsculas, números e hífens, com pelo menos 3 caracteres."
  }
}

variable "name_suffix" {
  description = "Sufixo opcional para garantir unicidade global do bucket (ex.: equipe ou hash curto)."
  type        = string
  default     = ""

  validation {
    condition     = var.name_suffix == "" || can(regex("^[a-z0-9-]+$", var.name_suffix))
    error_message = "O sufixo (quando informado) deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "enable_versioning" {
  description = "Habilita o versionamento do bucket S3."
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia server-side. Use AES256 (padrão) ou aws:kms."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser 'AES256' ou 'aws:kms'."
  }
}

variable "kms_key_arn" {
  description = "ARN da KMS Key para SSE-KMS (obrigatório quando sse_algorithm = 'aws:kms')."
  type        = string
  default     = ""

  validation {
    condition     = (var.sse_algorithm == "aws:kms" && length(var.kms_key_arn) > 0) || (var.sse_algorithm != "aws:kms")
    error_message = "kms_key_arn é obrigatório quando sse_algorithm = 'aws:kms'."
  }
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo com objetos. Recomendado manter false em produção."
  type        = bool
  default     = false
}

variable "additional_tags" {
  description = "Mapa de tags adicionais a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
