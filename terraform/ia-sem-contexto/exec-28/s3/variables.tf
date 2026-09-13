variable "bucket_name" {
  type        = string
  description = "Nome global do bucket S3 (deve seguir as regras de nomenclatura da AWS)."

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name deve ter entre 3 e 63 caracteres, apenas letras minusculas, numeros, pontos e hifens, comecando e terminando com letra ou numero."
  }
}

variable "environment" {
  type        = string
  description = "Nome do ambiente (ex: dev, staging, prod), usado apenas para tags."
  default     = "dev"
}

variable "enable_versioning" {
  type        = bool
  description = "Habilita versionamento de objetos no bucket."
  default     = true
}

variable "kms_key_arn" {
  type        = string
  description = "ARN de uma chave KMS customer-managed para criptografia SSE-KMS. Se nulo, usa criptografia SSE-S3 (AES256)."
  default     = null
}

variable "force_destroy" {
  type        = bool
  description = "Permite destruir o bucket mesmo que contenha objetos. Recomendado manter false em producao."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais a serem aplicadas ao bucket."
  default     = {}
}
