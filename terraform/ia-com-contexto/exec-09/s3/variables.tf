variable "environment" {
  description = "Ambiente alvo. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/produto (minusculo, sem espacos)."
  type        = string

  validation {
    condition     = length(var.system) > 0 && can(regex("^[a-z0-9-]+$", var.system))
    error_message = "system deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "region" {
  description = "Regiao AWS para o provider (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "region deve seguir o padrao de regioes AWS, por exemplo: us-east-1."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias."
  type        = map(string)
  default     = {}
}

variable "purpose" {
  description = "Finalidade do recurso (parte final do padrao de nome)."
  type        = string

  validation {
    condition     = length(var.purpose) > 0 && can(regex("^[a-z0-9-]+$", var.purpose))
    error_message = "purpose deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "versioning_status" {
  description = "Status do versionamento do bucket. Valores: Enabled ou Suspended."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "versioning_status deve ser Enabled ou Suspended."
  }
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia server-side. Valores: AES256 (padrao) ou aws:kms."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser AES256 ou aws:kms."
  }
}

variable "kms_key_arn" {
  description = "ARN da chave KMS quando sse_algorithm=aws:kms."
  type        = string
  default     = ""

  validation {
    condition     = var.sse_algorithm != "aws:kms" || (var.sse_algorithm == "aws:kms" && length(var.kms_key_arn) > 0)
    error_message = "kms_key_arn deve ser informado quando sse_algorithm=aws:kms."
  }
}

variable "force_destroy" {
  description = "Forca a destruicao do bucket mesmo se houver objetos. Padrao: false."
  type        = bool
  default     = false
}
