variable "aws_region" {
  description = "Regiao AWS onde os recursos serao criados."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome do bucket S3. Deve ser globalmente unico e seguir as regras de nomenclatura do S3."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usar apenas letras minusculas, numeros, pontos e hifens, e comecar/terminar com letra ou numero."
  }
}

variable "force_destroy" {
  description = "Se true, permite excluir o bucket mesmo que contenha objetos."
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Habilita o versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Se nao informado, o bucket usa criptografia AES256 gerenciada pelo S3."
  type        = string
  default     = null
}

variable "tags" {
  description = "Mapa de tags a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}

variable "lifecycle_rules" {
  description = "Lista de regras de ciclo de vida do bucket."
  type = list(object({
    id                                 = string
    enabled                            = bool
    expiration_days                    = optional(number)
    noncurrent_version_expiration_days = optional(number)
  }))
  default = []
}
