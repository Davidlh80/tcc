variable "bucket_name" {
  description = "Nome globalmente unico do bucket S3."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usando apenas letras minusculas, numeros, pontos e hifens."
  }
}

variable "force_destroy" {
  description = "Permite excluir o bucket mesmo que contenha objetos."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Habilita o versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS para criptografia server-side. Se nulo, usa AES256 gerenciado pelo S3."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags adicionais aplicadas ao bucket."
  type        = map(string)
  default     = {}
}

variable "lifecycle_rules" {
  description = "Lista de regras de ciclo de vida do bucket."
  type = list(object({
    id                                  = string
    enabled                             = bool
    prefix                              = optional(string)
    expiration_days                     = optional(number)
    noncurrent_version_expiration_days  = optional(number)
  }))
  default = []
}
