variable "environment" {
  description = "Ambiente alvo. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O parâmetro environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/produto (somente minúsculas, números e hifens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "O parâmetro system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "purpose" {
  description = "Finalidade do recurso (somente minúsculas, números e hifens). Ex.: logs, assets, backups."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.purpose)) && length(var.purpose) > 0
    error_message = "O parâmetro purpose deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS onde o recurso será provisionado. Ex.: us-east-1."
  type        = string

  validation {
    condition     = length(trim(var.region)) > 0
    error_message = "O parâmetro region não pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Mapa de tags adicionais a serem aplicadas aos recursos. Tags obrigatórias são impostas pelo template."
  type        = map(string)
  default     = {}
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

variable "sse_algorithm" {
  description = "Algoritmo de criptografia server-side. Valores permitidos: AES256 (padrão) ou aws:kms."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser AES256 ou aws:kms."
  }
}

variable "force_destroy" {
  description = "Quando true, permite destruir o bucket mesmo com objetos. Padrão: false."
  type        = bool
  default     = false
}
