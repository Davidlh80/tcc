variable "aws_region" {
  description = "Região AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(var.aws_region) > 0
    error_message = "aws_region não pode ser vazio."
  }
}

variable "bucket_name" {
  description = "Nome globalmente único do bucket S3."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name deve seguir as regras de nome do S3: 3-63 caracteres, letras minúsculas, números, pontos e hífens; começar e terminar com letra ou número."
  }
}

variable "environment" {
  description = "Ambiente de implantação (ex.: dev, staging, prod, test)."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod", "test"], var.environment)
    error_message = "environment deve ser um dos: dev, staging, prod, test."
  }
}

variable "versioning_enabled" {
  description = "Habilita o versionamento do bucket."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo se houver objetos. Use com cautela."
  type        = bool
  default     = false
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia padrão do bucket (AES256 ou aws:kms)."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser AES256 ou aws:kms."
  }
}

variable "sse_kms_key_arn" {
  description = "ARN da KMS Key para criptografia (necessário apenas se desejar chave específica com aws:kms)."
  type        = string
  default     = null

  validation {
    condition     = var.sse_kms_key_arn == null || can(regex("^arn:aws(-[a-z]+)?:kms:[a-z0-9-]+:\\d{12}:key\\/.+", var.sse_kms_key_arn))
    error_message = "sse_kms_key_arn deve ser um ARN válido de chave KMS ou null."
  }
}

variable "logging_enabled" {
  description = "Habilita o access logging do S3 para um bucket de logs."
  type        = bool
  default     = false
}

variable "logging_target_bucket" {
  description = "Nome do bucket de logs existente que irá receber os access logs."
  type        = string
  default     = null

  validation {
    condition     = var.logging_enabled == false || (var.logging_target_bucket != null && var.logging_target_bucket != "" && var.logging_target_bucket != var.bucket_name)
    error_message = "Quando logging_enabled é true, logging_target_bucket deve ser definido, não pode ser vazio e não pode ser igual ao bucket_name."
  }
}

variable "logging_target_prefix" {
  description = "Prefixo (pasta) dentro do bucket de logs para armazenar os access logs."
  type        = string
  default     = "s3-access-logs/"
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas aos recursos."
  type        = map(string)
  default     = {}
}
