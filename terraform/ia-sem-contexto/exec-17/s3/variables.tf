variable "region" {
  description = "Região AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"
  validation {
    condition     = can(regex("^[a-z]{2}(-gov)?-[a-z]+-\\d$", var.region))
    error_message = "A região deve estar no formato ex: us-east-1, eu-west-1, us-gov-west-1."
  }
}

variable "bucket_name" {
  description = "Nome globalmente único do bucket S3 (3-63 chars, letras minúsculas, números, pontos e hífens)."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9](?:[a-z0-9.-]{1,61})[a-z0-9]$", var.bucket_name)) && !contains(var.bucket_name, "..")
    error_message = "bucket_name inválido. Use 3-63 chars, apenas [a-z0-9.-], não inicie/termine com hífen/ponto e evite '..'."
  }
}

variable "tags" {
  description = "Tags padrão para aplicar aos recursos."
  type        = map(string)
  default     = {}
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo se contiver objetos."
  type        = bool
  default     = false
}

variable "prevent_destroy" {
  description = "Protege o bucket contra destruição acidental via Terraform."
  type        = bool
  default     = true
}

variable "enable_versioning" {
  description = "Habilita o versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia do lado do servidor (SSE) padrão para o bucket."
  type        = string
  default     = "AES256"
  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser 'AES256' ou 'aws:kms'."
  }
}

variable "kms_key_id" {
  description = "ARN ou ID da CMK do KMS a ser usada quando sse_algorithm='aws:kms'."
  type        = string
  default     = null
  validation {
    condition     = var.sse_algorithm != "aws:kms" || (var.kms_key_id != null && trim(var.kms_key_id) != "")
    error_message = "kms_key_id deve ser informado quando sse_algorithm for 'aws:kms'."
  }
}

variable "enable_bucket_key" {
  description = "Habilita S3 Bucket Keys para reduzir custos com SSE-KMS."
  type        = bool
  default     = true
}

variable "require_encryption" {
  description = "Se true, aplica política negando uploads sem criptografia adequada."
  type        = bool
  default     = true
}

variable "attach_policy" {
  description = "Se true, anexa política ao bucket para reforçar TLS e (opcionalmente) criptografia."
  type        = bool
  default     = true
}
