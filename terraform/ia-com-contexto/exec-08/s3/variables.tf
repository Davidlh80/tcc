variable "environment" {
  description = "Ambiente alvo do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dentre: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/aplicacao (minusculo, alfanumerico e hifens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "region" {
  description = "Regiao AWS onde o bucket sera criado (ex.: us-east-1)."
  type        = string

  validation {
    condition     = length(var.region) > 0
    error_message = "region nao pode ser vazio."
  }
}

variable "purpose" {
  description = "Finalidade do recurso (minusculo, alfanumerico e hifens), usado na nomenclatura."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.purpose)) && length(var.purpose) > 0
    error_message = "purpose deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "versioning_enabled" {
  description = "Habilita o versionamento do bucket S3. Por padrao, Enabled."
  type        = bool
  default     = true
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas. Em caso de conflito, as tags obrigatorias prevalecem."
  type        = map(string)
  default     = {}
}
