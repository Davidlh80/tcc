variable "bucket_name" {
  description = "Nome do bucket S3"
  type        = string
}

variable "environment" {
  description = "Ambiente onde o recurso sera utilizado"
  type        = string
  default     = "dev"
}

variable "versioning_enabled" {
  description = "Define se o versionamento do bucket sera habilitado"
  type        = bool
  default     = true
}

variable "additional_tags" {
  description = "Tags adicionais para o bucket"
  type        = map(string)
  default     = {}
}
