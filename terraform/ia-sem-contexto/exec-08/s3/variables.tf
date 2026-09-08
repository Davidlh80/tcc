variable "aws_region" {
  description = "Região AWS para o provider."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(var.aws_region) > 0
    error_message = "aws_region não pode ser vazio."
  }
}

variable "bucket_name" {
  description = "Nome do bucket S3 (globalmente único)."
  type        = string

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres."
  }

  validation {
    condition     = can(regex("^([a-z0-9][a-z0-9.-]{1,61}[a-z0-9])$", var.bucket_name))
    error_message = "O nome do bucket deve conter apenas letras minúsculas, números, hifens e pontos, não podendo iniciar/terminar com ponto ou hífen."
  }
}

variable "force_destroy" {
  description = "Força a destruição do bucket mesmo se contiver objetos."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Habilita versionamento do bucket."
  type        = bool
  default     = true
}

variable "object_ownership" {
  description = "Modo de ownership de objetos. Recomenda-se BucketOwnerEnforced para desabilitar ACLs."
  type        = string
  default     = "BucketOwnerEnforced"

  validation {
    condition     = contains(["BucketOwnerEnforced", "BucketOwnerPreferred", "ObjectWriter"], var.object_ownership)
    error_message = "object_ownership deve ser um de: BucketOwnerEnforced, BucketOwnerPreferred, ObjectWriter."
  }
}

variable "block_public_acls" {
  description = "Bloqueia ACLs públicas no bucket."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignora ACLs públicas aplicadas aos objetos."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Bloqueia políticas públicas do bucket."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restringe acesso público aos buckets com políticas públicas."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN da CMK do AWS KMS para criptografia do bucket (opcional). Se vazio, usa SSE-S3 (AES256)."
  type        = string
  default     = ""

  validation {
    condition     = var.kms_key_arn == "" || can(regex("^arn:aws(-[a-z]+)?:kms:[a-z0-9-]+:\\d{12}:key\\/.+", var.kms_key_arn))
    error_message = "kms_key_arn deve ser vazio ou um ARN válido de chave KMS (formato arn:...:kms:...:key/...)."
  }
}

variable "enable_bucket_key" {
  description = "Habilita S3 Bucket Keys quando usando SSE-KMS para reduzir custos."
  type        = bool
  default     = true
}

variable "logging_target_bucket" {
  description = "Bucket alvo para Server Access Logging (opcional)."
  type        = string
  default     = ""
}

variable "logging_prefix" {
  description = "Prefixo dos logs no bucket de logging."
  type        = string
  default     = "s3-access-logs/"
}

variable "tags" {
  description = "Tags adicionais a aplicar no bucket."
  type        = map(string)
  default     = {}
}
