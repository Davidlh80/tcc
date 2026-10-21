variable "bucket_name" {
  description = "Nome do bucket S3 a ser criado"
  type        = string
}

variable "environment" {
  description = "Ambiente de implantação (ex: dev, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "prd"], var.environment)
    error_message = "O valor da variável 'environment' deve ser 'dev' ou 'prd'."
  }
}

variable "versioning_enabled" {
  description = "Habilitar versionamento no bucket S3"
  type        = bool
  default     = true
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas ao bucket S3"
  type        = map(string)
  default     = {}
}