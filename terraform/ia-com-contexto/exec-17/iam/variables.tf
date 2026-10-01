variable "environment" {
  description = "Ambiente de implantacao do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser dev, hml ou prd."
  }
}

variable "system" {
  description = "Identificador do sistema/aplicacao proprietaria do recurso, usado na nomenclatura padronizada."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system))
    error_message = "O valor de system deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "region" {
  description = "Regiao AWS onde o provider sera configurado."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "O valor de region deve seguir o formato de regiao AWS, ex.: us-east-1."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da IAM Policy/Role, usada na nomenclatura padronizada (<ambiente>-<sistema>-<recurso>-<finalidade>)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "O valor de policy_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "trusted_principal_arn" {
  description = "ARN unico do principal autorizado a assumir a IAM Role (trust policy). Nao pode ser um wildcard."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:.+$", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM valido e especifico, nunca \"*\"."
  }
}

variable "allowed_actions" {
  description = "Lista de IAM Actions permitidas na statement Allow da policy. Nao pode conter \"*\" combinado com allowed_resources \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma action."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs/recursos permitidos na statement Allow da policy. Nao pode conter \"*\" combinado com allowed_actions \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }
}
