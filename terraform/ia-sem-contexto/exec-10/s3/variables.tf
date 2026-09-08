variable "aws_region" {
  description = "Região AWS onde o bucket S3 será criado."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "A região deve seguir o formato esperado, por exemplo: us-east-1, us-west-2, eu-central-1."
  }
}

variable "bucket_name" {
  description = "Nome globalmente único do bucket S3."
  type        = string

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres."
  }

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]+[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve conter apenas letras minúsculas, números, pontos e hifens, iniciar e terminar com letra/número."
  }

  validation {
    condition     = !contains(var.bucket_name, "..")
    error_message = "O nome do bucket não pode conter '..'."
  }

  validation {
    condition     = !can(regex("^(\\d{1,3}\\.){3}\\d{1,3}$", var.bucket_name))
    error_message = "O nome do bucket não pode ter formato de endereço IPv4."
  }
}

variable "force_destroy" {
  description = "Se true, permite destruir o bucket mesmo se não estiver vazio."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Habilita o versionamento no bucket."
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "ID ou ARN da KMS Key para criptografia SSE-KMS. Quando null, usa SSE-S3 (AES256)."
  type        = string
  default     = null
}

variable "bucket_key_enabled" {
  description = "Habilita S3 Bucket Keys para SSE-KMS (reduz custo de requisições KMS). Só tem efeito quando kms_key_id não é null."
  type        = bool
  default     = true
}

variable "enable_access_logging" {
  description = "Habilita Server Access Logging para o bucket."
  type        = bool
  default     = false
}

variable "access_log_bucket_name" {
  description = "Nome do bucket de logs (deve ser diferente do bucket principal). Obrigatório se enable_access_logging = true."
  type        = string
  default     = null

  validation {
    condition     = var.enable_access_logging == false || (var.access_log_bucket_name != null && var.access_log_bucket_name != var.bucket_name)
    error_message = "Quando enable_access_logging é true, access_log_bucket_name deve ser informado e ser diferente de bucket_name."
  }
}

variable "access_log_prefix" {
  description = "Prefixo para objetos de log no bucket de logs."
  type        = string
  default     = "s3-access-logs/"

  validation {
    condition     = !can(regex("^/.*", var.access_log_prefix))
    error_message = "O prefixo de log não deve começar com '/'."
  }
}

variable "abort_incomplete_multipart_upload_days" {
  description = "Dias para abortar uploads multipart incompletos."
  type        = number
  default     = 7

  validation {
    condition     = var.abort_incomplete_multipart_upload_days >= 1 && var.abort_incomplete_multipart_upload_days <= 365
    error_message = "Informe um valor entre 1 e 365 dias para abortar uploads incompletos."
  }
}

variable "block_public_acls" {
  description = "Bloqueia ACLs públicas no bucket."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Bloqueia políticas públicas no bucket."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignora (rejeita) ACLs públicas aplicadas a objetos no bucket."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restringe acesso público ao bucket mesmo que a política permita."
  type        = bool
  default     = true
}

variable "object_ownership" {
  description = "Controle de propriedade de objetos do bucket."
  type        = string
  default     = "BucketOwnerEnforced"

  validation {
    condition     = contains(["BucketOwnerEnforced", "BucketOwnerPreferred", "ObjectWriter"], var.object_ownership)
    error_message = "object_ownership deve ser um de: BucketOwnerEnforced, BucketOwnerPreferred, ObjectWriter."
  }
}

variable "tags" {
  description = "Tags a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
