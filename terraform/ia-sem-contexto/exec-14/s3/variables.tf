variable "aws_region" {
  description = "Regiao AWS onde o bucket S3 sera criado."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome do bucket S3 (deve ser globalmente unico)."
  type        = string

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63 && can(regex("^[a-z0-9][a-z0-9.-]+[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name deve ter entre 3 e 63 caracteres, conter apenas letras minusculas, numeros, hifens e pontos, e nao pode iniciar/terminar com ponto ou hifen."
  }
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo com objetos (cuidado em ambientes de producao)."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Ativa o versionamento do bucket."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN da chave KMS para criptografia SSE-KMS. Se nulo, usa SSE-S3 (AES256)."
  type        = string
  default     = null
}

variable "bucket_key_enabled" {
  description = "Ativa S3 Bucket Keys para reduzir custos com SSE-KMS (aplicavel quando kms_key_arn nao for nulo)."
  type        = bool
  default     = true
}

variable "enforce_sse" {
  description = "Se true, nega uploads sem cabecalho de SSE ou com algoritmo incorreto."
  type        = bool
  default     = true
}

variable "enforce_kms_key" {
  description = "Se true e kms_key_arn definido, nega uploads que nao usem exatamente essa KMS Key."
  type        = bool
  default     = false
}

variable "enable_access_logging" {
  description = "Habilita server access logging para um bucket de logs existente."
  type        = bool
  default     = false
}

variable "log_bucket_name" {
  description = "Nome do bucket de destino para access logs (deve existir previamente). Obrigatorio se enable_access_logging = true."
  type        = string
  default     = null
}

variable "log_object_prefix" {
  description = "Prefixo para os arquivos de log no bucket de logs."
  type        = string
  default     = "s3-logs/"
}

variable "enable_lifecycle" {
  description = "Cria regra de lifecycle para abortar uploads multipart incompletos."
  type        = bool
  default     = true
}

variable "abort_incomplete_mpu_days" {
  description = "Dias para abortar uploads multipart incompletos."
  type        = number
  default     = 7

  validation {
    condition     = var.abort_incomplete_mpu_days >= 1 && var.abort_incomplete_mpu_days <= 365
    error_message = "abort_incomplete_mpu_days deve estar entre 1 e 365."
  }
}

variable "block_public_acls" {
  description = "Bloqueia ACLs publicas no bucket."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignora ACLs publicas que possam ser aplicadas aos objetos."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Bloqueia politicas publicas no bucket."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restringe buckets publicos a apenas solicitacoes autorizadas."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
