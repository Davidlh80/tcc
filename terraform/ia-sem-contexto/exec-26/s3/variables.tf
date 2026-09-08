variable "aws_region" {
  description = "Regiao AWS onde os recursos serao criados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "A regiao deve seguir o padrao ex: us-east-1, eu-west-1."
  }
}

variable "bucket_name" {
  description = "Nome do bucket S3 (globalmente unico). Deve ter entre 3 e 63 caracteres, somente letras minusculas, numeros e hifens. Deve comecar e terminar com letra ou numero."
  type        = string

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres."
  }

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O bucket deve conter apenas letras minusculas, numeros e hifens, iniciando e terminando com letra ou numero."
  }
}

variable "enable_versioning" {
  description = "Habilita o versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo com objetos. Mantenha false para maior seguranca."
  type        = bool
  default     = false
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia do lado do servidor. Use AES256 (padrao) ou aws:kms."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser 'AES256' ou 'aws:kms'."
  }
}

variable "kms_key_id" {
  description = "ARN ou ID da chave KMS quando sse_algorithm for 'aws:kms'."
  type        = string
  default     = null

  validation {
    condition     = var.sse_algorithm != "aws:kms" || (var.kms_key_id != null && trim(var.kms_key_id) != "")
    error_message = "Quando sse_algorithm for 'aws:kms', kms_key_id deve ser informado."
  }
}

variable "bucket_key_enabled" {
  description = "Habilita S3 Bucket Keys para reduzir custo de KMS quando 'aws:kms' for usado."
  type        = bool
  default     = true
}

variable "block_public_acls" {
  description = "Bloqueia ACLs publicas no bucket."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Bloqueia politicas publicas no bucket."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignora ACLs publicas nos objetos."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restringe acesso publico a buckets com politicas que permitam acesso publico."
  type        = bool
  default     = true
}

variable "attach_deny_insecure_transport_policy" {
  description = "Anexa politica que nega acesso via HTTP nao seguro (somente HTTPS)."
  type        = bool
  default     = true
}

variable "log_bucket_name" {
  description = "Bucket alvo para logs de acesso do S3. Deixe vazio para desabilitar logging."
  type        = string
  default     = ""

  validation {
    condition     = var.log_bucket_name == "" || var.log_bucket_name != var.bucket_name
    error_message = "O bucket de logs nao pode ser o mesmo que o bucket principal."
  }
}

variable "log_prefix" {
  description = "Prefixo para objetos de log de acesso, caso logging esteja habilitado."
  type        = string
  default     = "s3-access-logs/"

  validation {
    condition     = endswith(var.log_prefix, "/")
    error_message = "O prefixo de logs deve terminar com '/'."
  }
}

variable "tags" {
  description = "Tags padrao aplicadas aos recursos."
  type        = map(string)
  default     = {
    ManagedBy = "Terraform"
  }
}
