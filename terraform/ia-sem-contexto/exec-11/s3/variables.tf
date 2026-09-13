variable "aws_region" {
  description = "Região AWS onde o bucket será provisionado."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome globalmente único do bucket S3."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usando apenas letras minúsculas, números, pontos e hifens."
  }
}

variable "environment" {
  description = "Nome do ambiente (ex.: dev, staging, prod), usado apenas para fins de tag."
  type        = string
  default     = "dev"
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo que contenha objetos. Use com cautela."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Habilita versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS customizada para criptografia SSE-KMS. Se nulo, usa SSE-S3 (AES256)."
  type        = string
  default     = null
}

variable "logging_target_bucket" {
  description = "Nome do bucket de destino para logs de acesso ao S3. Se nulo, o logging não é habilitado."
  type        = string
  default     = null
}

variable "logging_target_prefix" {
  description = "Prefixo aplicado aos objetos de log gravados no bucket de destino."
  type        = string
  default     = "log/"
}

variable "lifecycle_rules" {
  description = "Lista de regras de ciclo de vida a aplicar ao bucket."
  type = list(object({
    id                         = string
    enabled                    = bool
    prefix                     = optional(string, "")
    expiration_days            = optional(number)
    noncurrent_expiration_days = optional(number)
  }))
  default = []
}

variable "tags" {
  description = "Tags adicionais a serem mescladas com as tags padrão do bucket."
  type        = map(string)
  default     = {}
}
