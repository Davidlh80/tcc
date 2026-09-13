variable "bucket_name" {
  description = "Nome do bucket S3. Deve ser globalmente unico e seguir as convencoes de nomenclatura da AWS (3 a 63 caracteres, letras minusculas, numeros, pontos e hifens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, conter apenas letras minusculas, numeros, pontos e hifens, e comecar/terminar com letra ou numero."
  }
}

variable "aws_region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "force_destroy" {
  description = "Permite que o bucket seja destruido mesmo contendo objetos. Use com cautela em ambientes produtivos."
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Habilita versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "enable_kms_encryption" {
  description = "Se verdadeiro, usa criptografia SSE-KMS; caso contrario, usa SSE-S3 (AES256)."
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "ARN da chave KMS usada para criptografia do bucket quando enable_kms_encryption for verdadeiro. Se vazio, sera usada a chave gerenciada pela AWS (aws/s3)."
  type        = string
  default     = ""
}

variable "block_public_access" {
  description = "Bloqueia todo acesso publico ao bucket (ACLs e policies). Recomendado manter como verdadeiro."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Mapa de tags a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
