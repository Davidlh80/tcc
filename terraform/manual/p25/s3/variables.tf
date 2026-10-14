variable "aws_region" {
  type        = string
  description = "Região da AWS onde os recursos serão criados"
  default     = "us-east-1"
}

variable "bucket_name" {
  type        = string
  description = "Nome globalmente único do bucket S3"
}

variable "environment" {
  type        = string
  description = "Ambiente de implantação (ex: dev, hml, prod)"
  default     = "dev"
}

variable "enable_versioning" {
  type        = bool
  description = "Define se o versionamento do S3 será habilitado (true/false)"
  default     = true
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais opcionais para o bucket"
  default     = {}
}
