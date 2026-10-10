variable "environment" {
  description = "Ambiente de implantacao."
  type        = string
  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "Use dev, hml ou prd."
  }
}

variable "system" {
  description = "Identificacao do sistema."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.system))
    error_message = "Use letras minusculas, numeros e hifens entre segmentos."
  }
}

variable "region" {
  description = "Regiao AWS."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais; tags obrigatorias prevalecem."
  type        = map(string)
  default     = {}
}

variable "purpose" {
  description = "Finalidade do bucket; deve tornar o nome globalmente unico."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.purpose))
    error_message = "Use letras minusculas, numeros e hifens entre segmentos."
  }
}

variable "versioning_enabled" {
  description = "Habilitar versionamento; false suspende novas versoes."
  type        = bool
  default     = true
}
