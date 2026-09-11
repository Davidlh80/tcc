variable "environment" {
  description = "Ambiente alvo. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um de: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador curto do sistema/produto (ex.: tcc). Use apenas letras minúsculas, números e hifens."
  type        = string

  validation {
    condition     = length(var.system) > 0 && can(regex("^[a-z0-9-]+$", var.system))
    error_message = "system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS onde os recursos serão criados (ex.: us-east-1)."
  type        = string

  validation {
    condition     = length(trim(var.region)) > 0
    error_message = "region não pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Mapa de tags adicionais a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}

variable "purpose" {
  description = "Finalidade do recurso para compor o nome (ex.: logs, assets, backups)."
  type        = string

  validation {
    condition     = length(var.purpose) > 0 && can(regex("^[a-z0-9-]+$", var.purpose))
    error_message = "purpose deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "versioning_status" {
  description = "Status do versionamento do bucket. Valores permitidos: Enabled, Suspended. Padrão: Enabled."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "versioning_status deve ser Enabled ou Suspended."
  }
}

variable "force_destroy" {
  description = "Se true, permite destruir o bucket mesmo que contenha objetos. Padrão: false."
  type        = bool
  default     = false
}
