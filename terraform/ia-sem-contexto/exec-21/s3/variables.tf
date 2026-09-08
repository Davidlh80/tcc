variable "aws_region" {
  description = "Regiao AWS para o provider."
  type        = string
  default     = "us-east-1"
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "A regiao deve seguir o padrao ex: us-east-1, eu-west-1, sa-east-1."
  }
}

variable "bucket_name" {
  description = "Nome do bucket S3 (globalmente unico)."
  type        = string
  validation {
    condition = length(var.bucket_name) >= 3
      && length(var.bucket_name) <= 63
      && can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name deve ter 3-63 caracteres, apenas letras minusculas, numeros, pontos e hifens, iniciando e terminando com letra ou numero."
  }
}

variable "force_destroy" {
  description = "Forca a destruicao do bucket mesmo se houver objetos."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Ativa versionamento do bucket."
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia padrao do bucket (AES256 ou aws:kms)."
  type        = string
  default     = "AES256"
  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser 'AES256' ou 'aws:kms'."
  }
}

variable "sse_kms_key_id" {
  description = "ARN ou alias da KMS Key ao usar aws:kms (opcional; se nao informado, a chave gerenciada pela AWS pode ser usada)."
  type        = string
  default     = null
}

variable "enable_bucket_key" {
  description = "Ativa S3 Bucket Keys para reduzir custos de KMS quando aws:kms for usado."
  type        = bool
  default     = true
}

variable "attach_deny_insecure_transport" {
  description = "Anexa politica que nega trafego sem TLS (aws:SecureTransport=false)."
  type        = bool
  default     = true
}

variable "block_public_acls" {
  description = "Bloqueia ACLs publicas."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignora ACLs publicas."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Bloqueia politicas publicas."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restringe acesso publico total ao bucket."
  type        = bool
  default     = true
}

variable "default_tags" {
  description = "Tags padrao aplicadas via provider a todos os recursos."
  type        = map(string)
  default     = {}
}

variable "bucket_tags" {
  description = "Tags especificas do bucket."
  type        = map(string)
  default     = {}
}
