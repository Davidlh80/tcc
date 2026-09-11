variable "environment" {
  description = "Ambiente onde o bucket sera criado. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O ambiente deve ser um dos valores: dev, hml ou prd."
  }
}

variable "system" {
  description = "Identificador do sistema (minusculo, numeros e hifens). Usado no padrao <environment>-<system>-s3-<purpose>."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "O sistema deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "purpose" {
  description = "Finalidade do bucket (minusculo, numeros e hifens). Usado no padrao <environment>-<system>-s3-<purpose>."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.purpose)) && length(var.purpose) > 0
    error_message = "A finalidade deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "region" {
  description = "Regiao AWS para o provider."
  type        = string

  validation {
    condition     = length(var.region) > 0
    error_message = "A regiao nao pode ser vazia."
  }
}

variable "additional_tags" {
  description = "Mapa de tags adicionais a serem aplicadas aos recursos. Em caso de conflito, as tags obrigatorias prevalecem."
  type        = map(string)
  default     = {}
}

variable "versioning_status" {
  description = "Estado do versionamento do bucket. Valores permitidos: Enabled ou Suspended. Padrao: Enabled."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "versioning_status deve ser Enabled ou Suspended."
  }
}

variable "force_destroy" {
  description = "Se true, permite destruir o bucket mesmo com objetos (use com cautela). Padrao: false."
  type        = bool
  default     = false
}
