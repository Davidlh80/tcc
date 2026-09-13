variable "aws_region" {
  description = "Região AWS onde o bucket S3 será criado."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome globalmente único do bucket S3."
  type        = string
}

variable "environment" {
  description = "Nome do ambiente (ex.: dev, staging, prod), usado em tags."
  type        = string
  default     = "dev"
}

variable "versioning_enabled" {
  description = "Habilita o versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN de uma chave KMS para criptografia SSE-KMS. Se null, usa SSE-S3 (AES256)."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo que contenha objetos. Deve ser false em produção."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags adicionais aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
