variable "aws_region" {
  type        = string
  description = "Regiao AWS onde o bucket sera criado."
  default     = "us-east-1"
}

variable "bucket_name" {
  type        = string
  description = "Nome globalmente unico do bucket S3, seguindo as regras de nomenclatura da AWS."

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usar apenas letras minusculas, numeros, pontos e hifens, e comecar/terminar com letra ou numero."
  }
}

variable "enable_versioning" {
  type        = bool
  description = "Habilita o versionamento de objetos no bucket."
  default     = true
}

variable "force_destroy" {
  type        = bool
  description = "Permite que o Terraform destrua o bucket mesmo que contenha objetos. Use com cautela."
  default     = false
}

variable "kms_key_arn" {
  type        = string
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Se nao informado, usa criptografia SSE-S3 (AES256)."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais a serem aplicadas ao bucket."
  default     = {}
}
