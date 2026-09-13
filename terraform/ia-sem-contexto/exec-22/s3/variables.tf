variable "aws_region" {
  type        = string
  description = "Regiao AWS onde o bucket sera provisionado."
  default     = "us-east-1"
}

variable "bucket_name" {
  type        = string
  description = "Nome globalmente unico do bucket S3."

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, apenas letras minusculas, numeros, pontos e hifens, e nao pode comecar ou terminar com hifen ou ponto."
  }
}

variable "force_destroy" {
  type        = bool
  description = "Permite excluir o bucket mesmo que contenha objetos. Use com cautela."
  default     = false
}

variable "versioning_enabled" {
  type        = bool
  description = "Habilita o versionamento de objetos no bucket."
  default     = true
}

variable "kms_key_arn" {
  type        = string
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Se vazio, usa criptografia padrao AES256 (SSE-S3)."
  default     = ""
}

variable "logging_target_bucket" {
  type        = string
  description = "Nome do bucket de destino para logs de acesso. Se vazio, o logging nao e habilitado."
  default     = ""
}

variable "logging_target_prefix" {
  type        = string
  description = "Prefixo aplicado aos objetos de log de acesso, quando o logging esta habilitado."
  default     = "log/"
}

variable "lifecycle_rules" {
  description = "Lista de regras de ciclo de vida do bucket."
  type = list(object({
    id                                 = string
    enabled                            = bool
    prefix                             = optional(string, "")
    expiration_days                    = optional(number)
    noncurrent_version_expiration_days = optional(number)
  }))
  default = []
}

variable "tags" {
  type        = map(string)
  description = "Tags a serem aplicadas ao bucket."
  default     = {}
}
