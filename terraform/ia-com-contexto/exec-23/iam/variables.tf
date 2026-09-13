variable "environment" {
  type        = string
  description = "Ambiente de implantacao do recurso."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Identificador do sistema/aplicacao dono do recurso, usado na nomenclatura padronizada."

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system))
    error_message = "system deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "region" {
  type        = string
  description = "Regiao AWS utilizada para configurar o provider."
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "region deve seguir o formato de regiao AWS, ex.: us-east-1."
  }
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais mescladas as tags obrigatorias da organizacao."
  default     = {}
}

variable "policy_name" {
  type        = string
  description = "Finalidade da IAM Policy, utilizada no padrao de nomenclatura <ambiente>-<sistema>-iam-<finalidade>."

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "policy_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de IAM Actions permitidas na policy (principio do menor privilegio)."

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma action."
  }

  validation {
    condition     = alltrue([for action in var.allowed_actions : length(action) > 0])
    error_message = "allowed_actions nao pode conter strings vazias."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos aos quais as actions informadas serao permitidas."

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso (ARN)."
  }

  validation {
    condition     = alltrue([for resource in var.allowed_resources : length(resource) > 0])
    error_message = "allowed_resources nao pode conter strings vazias."
  }
}
