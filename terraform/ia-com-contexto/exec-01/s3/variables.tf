variable "environment" {
  description = "Ambiente alvo (dev, hml, prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema/aplicação (minúsculo, sem espaços)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas letras minúsculas, números e hifens."
  }
}

variable "region" {
  description = "Região AWS onde os recursos serão provisionados (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "region deve corresponder ao padrão de regiões AWS (ex.: us-east-1)."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatórias."
  type        = map(string)
  default     = {}
}

variable "purpose" {
  description = "Finalidade do recurso para composição do nome (ex.: logs, app, data)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{1,63}$", var.purpose))
    error_message = "purpose deve conter entre 1 e 63 caracteres: letras minúsculas, números e hifens."
  }
}

variable "versioning_enabled" {
  description = "Habilita (true) ou suspende (false) o versionamento do bucket. Padrão: true (Enabled)."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo com objetos (use com cautela)."
  type        = bool
  default     = false
}
