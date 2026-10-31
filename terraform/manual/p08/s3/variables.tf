variable "bucket_name" {
  description = "Nome globalmente único do bucket S3."
  type        = string

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres."
  }
}

variable "environment" {
  description = "Ambiente de implantação (ex.: dev, staging, prod)."
  type        = string
}

variable "versioning_enabled" {
  description = "Habilita o versionamento do bucket."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags adicionais para o bucket."
  type        = map(string)
  default     = {}
}
variable "aws_region" {
  description = "Região AWS."
  type        = string
  default     = "us-east-1"
}
