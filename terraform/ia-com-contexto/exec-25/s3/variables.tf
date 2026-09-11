variable "environment" {
  description = "Ambiente do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml ou prd."
  }
}

variable "system" {
  description = "Identificador do sistema/aplicação (minúsculo, números e hífens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+(-?[a-z0-9]+)*(-[a-z0-9]+)*$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "purpose" {
  description = "Finalidade do recurso (ex.: logs, assets, backups)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.purpose)) && length(var.purpose) > 0
    error_message = "purpose deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "region" {
  description = "Região AWS para criação do recurso (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d+$", var.region))
    error_message = "region deve seguir o padrão de regiões AWS, por exemplo: us-east-1, sa-east-1."
  }
}

variable "additional_tags" {
  description = "Mapa de tags adicionais a serem aplicadas aos recursos. Em caso de conflito, as tags obrigatórias prevalecem."
  type        = map(string)
  default     = {}
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
  description = "Se true, força a destruição do bucket mesmo se não estiver vazio."
  type        = bool
  default     = false
}
