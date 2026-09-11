variable "environment" {
  description = "Ambiente alvo do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um de: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema (minúsculo, números e hífens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "O valor de system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS para o provisionamento (ex.: us-east-1)."
  type        = string

  validation {
    condition     = length(trim(var.region)) > 0
    error_message = "A região não pode ser vazia."
  }
}

variable "purpose" {
  description = "Finalidade do recurso (segmento final do nome do bucket)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.purpose)) && length(var.purpose) > 0
    error_message = "purpose deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "versioning_enabled" {
  description = "Habilita (true) ou suspende (false) o versionamento do bucket. Padrão: Enabled (true)."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo se contiver objetos. Padrão: false."
  type        = bool
  default     = false
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia server-side. Conforme política, usar AES256 (SSE-S3)."
  type        = string
  default     = "AES256"

  validation {
    condition     = var.sse_algorithm == "AES256"
    error_message = "A política interna exige SSE-S3 com AES256."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas aos recursos. As tags obrigatórias da organização prevalecem."
  type        = map(string)
  default     = {}
}
