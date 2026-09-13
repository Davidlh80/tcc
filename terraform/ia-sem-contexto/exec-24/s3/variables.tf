variable "bucket_name" {
  type        = string
  description = "Nome do bucket S3. Deve ser globalmente unico e seguir as regras de nomenclatura da AWS (3 a 63 caracteres, letras minusculas, numeros, pontos e hifens)."

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O bucket_name deve ter entre 3 e 63 caracteres, usar apenas letras minusculas, numeros, pontos e hifens, e comecar/terminar com letra ou numero."
  }
}

variable "environment" {
  type        = string
  description = "Nome do ambiente (ex.: dev, staging, production), usado apenas para fins de tagueamento."
  default     = "production"
}

variable "force_destroy" {
  type        = bool
  description = "Permite que o Terraform destrua o bucket mesmo que contenha objetos. Mantenha false em ambientes produtivos."
  default     = false
}

variable "enable_versioning" {
  type        = bool
  description = "Habilita o versionamento de objetos no bucket."
  default     = true
}

variable "kms_key_arn" {
  type        = string
  description = "ARN de uma chave KMS para criptografia server-side (SSE-KMS). Se nao informado, o bucket usa criptografia padrao AES256 (SSE-S3)."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais a serem aplicadas ao bucket."
  default     = {}
}
