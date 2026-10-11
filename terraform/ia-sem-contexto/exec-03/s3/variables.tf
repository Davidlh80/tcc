variable "bucket_name" {
  description = "Nome do bucket S3. Deve ser globalmente unico."
  type        = string
}

variable "environment" {
  description = "Nome do ambiente (ex.: dev, staging, prod), usado para tagging."
  type        = string
  default     = "dev"
}

variable "versioning_enabled" {
  description = "Define se o versionamento do bucket deve estar habilitado."
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia server-side padrao do bucket. Valores aceitos: AES256 ou aws:kms."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser \"AES256\" ou \"aws:kms\"."
  }
}

variable "kms_key_arn" {
  description = "ARN da chave KMS usada para criptografia quando sse_algorithm for aws:kms. Ignorado quando sse_algorithm for AES256."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao bucket, mescladas com as tags padrao."
  type        = map(string)
  default     = {}
}
