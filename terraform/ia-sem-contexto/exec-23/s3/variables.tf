variable "region" {
  description = "Região AWS onde o bucket será criado."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(var.region) > 0
    error_message = "A região não pode ser vazia."
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
    error_message = "O nome do bucket deve conter apenas letras minúsculas, números, pontos e hifens; começar e terminar com alfanumérico."
  }
}

variable "enable_versioning" {
  description = "Habilita versionamento no bucket."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo se contiver objetos."
  type        = bool
  default     = false
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia do lado do servidor (SSE)."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser 'AES256' ou 'aws:kms'."
  }
}

variable "kms_key_id" {
  description = "ID ou ARN da KMS Key quando sse_algorithm = 'aws:kms'. Deixe nulo para AES256."
  type        = string
  default     = null
}

variable "enable_bucket_key" {
  description = "Habilita S3 Bucket Key para reduzir custo de requisições KMS (aplica para aws:kms)."
  type        = bool
  default     = true
}

variable "attach_tls_policy" {
  description = "Anexa política que nega acesso sem TLS."
  type        = bool
  default     = true
}

variable "block_public_acls" {
  description = "Bloqueia ACLs públicas."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignora ACLs públicas."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Bloqueia políticas públicas."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restringe acesso público ao bucket."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags adicionais a aplicar aos recursos."
  type        = map(string)
  default     = {}
}
