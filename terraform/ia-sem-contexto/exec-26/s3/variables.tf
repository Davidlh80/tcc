variable "aws_region" {
  type        = string
  description = "Regiao AWS onde o bucket S3 sera provisionado."
  default     = "us-east-1"
}

variable "bucket_name" {
  type        = string
  description = "Nome globalmente unico do bucket S3, seguindo as regras de nomenclatura da AWS."

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usando apenas letras minusculas, numeros, pontos e hifens, comecando e terminando com letra ou numero."
  }
}

variable "versioning_enabled" {
  type        = bool
  description = "Define se o versionamento de objetos do bucket sera habilitado (true) ou suspenso (false)."
  default     = true
}

variable "kms_key_arn" {
  type        = string
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Quando nulo, o bucket utiliza criptografia padrao AES256 (SSE-S3)."
  default     = null
}

variable "force_destroy" {
  type        = bool
  description = "Permite que o bucket seja destruido mesmo contendo objetos. Recomendado manter false em ambientes de producao."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Mapa de tags adicionais a serem aplicadas ao bucket."
  default     = {}
}
