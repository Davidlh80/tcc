variable "region" {
  description = "região aws onde será criado"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "ambiente do recurso (dev, hml ou prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O ambiente deve ser dev, hml ou prd."
  }
}

variable "bucket_name" {
  description = "Nome do meu bucket do s3."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter de 3 a 63 caracteres minúsculos, números, pontos ou hífens."
  }
}

variable "versioning_enabled" {
  description = "se o versionamento está habilitado"
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "destruir bucket, mesmo com objetos. Apenas para testes"
  type        = bool
  default     = false
}

variable "additional_tags" {
  description = "tags extras, além das obrigatórias"
  type        = map(string)
  default     = {}
}
