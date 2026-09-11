variable "environment" {
  description = "Ambiente alvo. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O environment deve ser um dos: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/aplicação (minúsculo, números e hífens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system))
    error_message = "O system deve conter apenas minúsculas, números e hífens."
  }
}

variable "region" {
  description = "Região AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "A região deve seguir o padrão, por ex.: us-east-1, sa-east-1, eu-west-1."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas ao bucket S3."
  type        = map(string)
  default     = {}
}

variable "purpose" {
  description = "Finalidade do bucket (parte final do nome). Use minúsculas, números e hífens."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.purpose))
    error_message = "A finalidade (purpose) deve conter apenas minúsculas, números e hífens."
  }
}

variable "versioning_status" {
  description = "Status do versionamento do bucket. Valores permitidos: Enabled ou Suspended. Padrão: Enabled."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "versioning_status deve ser Enabled ou Suspended."
  }
}

variable "force_destroy" {
  description = "Quando verdadeiro, permite destruir o bucket mesmo com objetos. Use com cautela."
  type        = bool
  default     = false
}
