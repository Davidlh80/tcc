variable "environment" {
  description = "Ambiente de implantação"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser dev, hml ou prd."
  }
}

variable "region" {
  description = "Região AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags extras aplicadas a todos os recursos"
  type        = map(string)
  default     = {}
}

variable "name" {
  type        = string
  description = "Nome do bucket S3"
}

variable "enable_versioning" {
  description = "Habilita o versionamento do bucket"
  type        = bool
  default     = true
}
