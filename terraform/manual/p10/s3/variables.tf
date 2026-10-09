variable "region" {
  description = "Regiao AWS onde o bucket sera criado."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome do bucket S3. Precisa ser unico globalmente."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name deve ter 3 a 63 caracteres, apenas minusculas, numeros e hifen."
  }
}

variable "environment" {
  description = "Ambiente do recurso: dev, hml ou prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser dev, hml ou prd."
  }
}

variable "enable_versioning" {
  description = "Habilita o versionamento dos objetos."
  type        = bool
  default     = true
}

variable "additional_tags" {
  description = "Tags extras. Nao sobrescrevem as tags obrigatorias."
  type        = map(string)
  default     = {}
}
