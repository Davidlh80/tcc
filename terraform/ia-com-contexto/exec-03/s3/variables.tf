variable "environment" {
  description = "Ambiente alvo. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O environment deve ser um dos: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/aplicação (min 3, máx 24; apenas minúsculas, números e hífens; não iniciar/terminar com hífen)."
  type        = string

  validation {
    condition     = length(var.system) >= 3 && length(var.system) <= 24
    error_message = "O system deve ter entre 3 e 24 caracteres."
  }

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]*[a-z0-9])?$", var.system))
    error_message = "O system deve conter apenas [a-z0-9-] e não iniciar/terminar com hífen."
  }
}

variable "purpose" {
  description = "Finalidade do bucket (min 3, máx 24; apenas minúsculas, números e hífens; não iniciar/terminar com hífen)."
  type        = string

  validation {
    condition     = length(var.purpose) >= 3 && length(var.purpose) <= 24
    error_message = "O purpose deve ter entre 3 e 24 caracteres."
  }

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]*[a-z0-9])?$", var.purpose))
    error_message = "O purpose deve conter apenas [a-z0-9-] e não iniciar/terminar com hífen."
  }
}

variable "enable_versioning" {
  description = "Habilita versionamento do bucket S3."
  type        = bool
  default     = true
}

variable "aws_region" {
  description = "Região AWS onde o bucket será criado."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "Região inválida. Exemplo: us-east-1, sa-east-1."
  }
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo contendo objetos. Use com cautela."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao bucket. As tags obrigatórias já são definidas pelo template."
  type        = map(string)
  default     = {}
}
