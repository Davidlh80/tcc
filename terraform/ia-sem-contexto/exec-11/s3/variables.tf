variable "region" {
  description = "Região AWS onde o bucket será criado."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "A região deve estar no formato válido, por exemplo: us-east-1, eu-west-1."
  }
}

variable "bucket_name" {
  description = "Nome do bucket S3 (único globalmente)."
  type        = string

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres."
  }

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve conter apenas letras minúsculas, números, pontos e hifens, iniciando e terminando com letra ou número."
  }

  validation {
    condition     = length(regexall("\\.\\.", var.bucket_name)) == 0
    error_message = "O nome do bucket não pode conter '..' (pontos consecutivos)."
  }
}

variable "tags" {
  description = "Tags adicionais a aplicar aos recursos."
  type        = map(string)
  default     = {}
}

variable "versioning_enabled" {
  description = "Habilita o versionamento do bucket."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo que existam objetos."
  type        = bool
  default     = false
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia do lado do servidor para o bucket (AES256 ou aws:kms)."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser 'AES256' ou 'aws:kms'."
  }
}

variable "kms_key_id" {
  description = "ID/ARN da KMS Key quando sse_algorithm for 'aws:kms'."
  type        = string
  default     = null
}

variable "enable_bucket_key" {
  description = "Habilita S3 Bucket Key quando usando KMS para reduzir custos de requisições KMS."
  type        = bool
  default     = true
}

variable "enable_logging" {
  description = "Habilita logging de acesso do bucket S3 para outro bucket."
  type        = bool
  default     = false
}

variable "logging_target_bucket" {
  description = "Bucket de destino para logs de acesso (requerido se enable_logging = true)."
  type        = string
  default     = null
}

variable "logging_target_prefix" {
  description = "Prefixo de objeto para os logs de acesso."
  type        = string
  default     = "s3-access-logs/"
}

variable "block_public_acls" {
  description = "Bloqueia ACLs públicas."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Bloqueia políticas públicas."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignora ACLs públicas."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restringe buckets públicos."
  type        = bool
  default     = true
}

variable "deny_insecure_transport" {
  description = "Cria política que nega acesso sem TLS (aws:SecureTransport = false)."
  type        = bool
  default     = true
}
