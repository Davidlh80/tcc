variable "environment" {
  description = "Ambiente de implantacao do recurso."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/aplicacao proprietaria do recurso, utilizado na nomenclatura padronizada."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system))
    error_message = "O valor de system deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "O valor de region deve seguir o formato de uma regiao AWS valida, ex.: us-east-1."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da IAM Policy/Role, utilizada como sufixo na nomenclatura padronizada (ex.: readonly, deploy)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "O valor de policy_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "allowed_actions" {
  description = "Lista de actions do IAM permitidas na statement Allow da policy. Nao pode conter \"*\" simultaneamente com allowed_resources contendo \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma action."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos permitidos na statement Allow da policy. Nao pode conter \"*\" simultaneamente com allowed_actions contendo \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }
}

variable "trusted_principal_arn" {
  description = "ARN unico do principal autorizado a assumir a IAM Role (trust policy). Nao e permitido usar \"*\"."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws:iam::[0-9]{12}:(root|user/.+|role/.+)$", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um unico ARN valido de conta, usuario ou role IAM, e nao pode ser \"*\"."
  }
}
