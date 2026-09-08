variable "aws_region" {
  description = "Região AWS para o provider."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(var.aws_region) > 0
    message       = "aws_region não pode ser vazio."
  }
}

variable "bucket_name" {
  description = "Nome do bucket S3 (deve ser globalmente único)."
  type        = string

  validation {
    condition = (
      can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name)) &&
      length(regexall("\\.\\.", var.bucket_name)) == 0 &&
      length(regexall("^(\\d{1,3}\\.){3}\\d{1,3}$", var.bucket_name)) == 0
    )
    message = "bucket_name deve ter 3-63 caracteres, apenas letras minúsculas, números, ponto e hífen, não pode iniciar/terminar com ponto ou hífen, não pode conter '..' e não pode ser um endereço IP."
  }
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo com objetos dentro."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Habilita o versionamento do bucket."
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia do lado do servidor (AES256 ou aws:kms)."
  type        = string
  default     = "aws:kms"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    message       = "sse_algorithm deve ser um de: AES256, aws:kms."
  }
}

variable "kms_key_arn" {
  description = "ARN da chave KMS para criptografia (opcional; se não definido com aws:kms, será usada a chave gerenciada AWS/S3)."
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_arn == null || var.kms_key_arn == "" || can(regex("^arn:aws:kms:[a-z0-9-]+:\\d{12}:key\\/.+", var.kms_key_arn))
    message       = "kms_key_arn deve ser um ARN válido de KMS (ex.: arn:aws:kms:REGION:ACCOUNT_ID:key/KEY_ID)."
  }

  validation {
    condition     = var.sse_algorithm != "AES256" || coalesce(var.kms_key_arn, "") == ""
    message       = "kms_key_arn deve ser omitido quando sse_algorithm = AES256."
  }
}

variable "enable_tls_policy" {
  description = "Cria política para negar tráfego sem TLS (aws:SecureTransport=false)."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : length(trim(k)) > 0 && length(trim(v)) > 0])
    message       = "Todas as chaves e valores de tags devem ser não vazios."
  }
}
