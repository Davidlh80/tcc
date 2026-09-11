variable "region" {
  description = "Região AWS onde os recursos serão criados (ex.: us-east-1)."
  type        = string

  validation {
    condition     = length(var.region) > 0
    error_message = "A variável 'region' é obrigatória e não pode ser vazia."
  }
}

variable "environment" {
  description = "Ambiente de implantação. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O 'environment' deve ser um de: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema (minúsculo, números e hífens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "A variável 'system' deve conter apenas [a-z0-9-] e não pode ser vazia."
  }
}

variable "purpose" {
  description = "Finalidade do recurso para composição do nome (minúsculo, números e hífens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.purpose)) && length(var.purpose) > 0
    error_message = "A variável 'purpose' deve conter apenas [a-z0-9-] e não pode ser vazia."
  }
}

variable "versioning_enabled" {
  description = "Se true, habilita o versionamento do bucket (padrão: true/Enabled)."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Se true, permite destruir o bucket mesmo com objetos (padrão: false)."
  type        = bool
  default     = false
}

variable "additional_tags" {
  description = "Tags adicionais para todos os recursos que suportam tags."
  type        = map(string)
  default     = {}

  validation {
    condition = length(setintersection(
      toset(keys(var.additional_tags)),
      toset(["Project", "Environment", "ManagedBy", "Owner", "CostCenter"])
    )) == 0
    error_message = "additional_tags não pode conter as chaves reservadas: Project, Environment, ManagedBy, Owner, CostCenter."
  }
}
