variable "environment" {
  description = "Ambiente do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/produto (minúsculo, números e hífens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{2,30}$", var.system))
    error_message = "system deve conter entre 2 e 30 caracteres, usando apenas [a-z0-9-]."
  }
}

variable "region" {
  description = "Região AWS para o provider (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "region deve seguir o padrão de regiões AWS (ex.: us-east-1)."
  }
}

variable "additional_tags" {
  description = "Mapa de tags adicionais a serem aplicadas ao bucket. Não sobrescreve tags mandatórias."
  type        = map(string)
  default     = {}
}

variable "purpose" {
  description = "Finalidade do recurso (parte final do nome)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{2,30}$", var.purpose))
    error_message = "purpose deve conter entre 2 e 30 caracteres, usando apenas [a-z0-9-]."
  }
}

variable "versioning_status" {
  description = "Status do versionamento do bucket. Valores permitidos: Enabled, Suspended. Padrão: Enabled."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "versioning_status deve ser 'Enabled' ou 'Suspended'."
  }
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia server-side. Padrão AES256. Opções: AES256, aws:kms."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser 'AES256' ou 'aws:kms'."
  }
}

variable "kms_key_id" {
  description = "ARN/ID da CMK para criptografia quando sse_algorithm = aws:kms. Obrigatório nesse caso; caso contrário, ignorado."
  type        = string
  default     = ""
}

variable "force_destroy" {
  description = "Se true, permite destruir o bucket mesmo se contiver objetos."
  type        = bool
  default     = false
}
