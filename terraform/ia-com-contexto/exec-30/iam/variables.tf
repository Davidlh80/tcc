variable "environment" {
  type        = string
  description = "Ambiente de implantacao do recurso (dev, hml ou prd)."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser dev, hml ou prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema/aplicacao ao qual o recurso pertence."

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  type        = string
  description = "Regiao AWS onde os recursos serao provisionados."
  default     = "us-east-1"
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais a serem mescladas as tags obrigatorias da organizacao."
  default     = {}
}

variable "policy_name" {
  type        = string
  description = "Finalidade da IAM Policy/Role, usada na nomenclatura padrao <ambiente>-<sistema>-<recurso>-<finalidade>."

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "O valor de policy_name nao pode ser vazio."
  }
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de acoes IAM permitidas (Effect Allow) na policy."

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma acao."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos aos quais a policy concede acesso."

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }
}

variable "trusted_principal_arn" {
  type        = string
  description = "ARN do principal (conta, role ou usuario IAM) autorizado a assumir a role via trust policy."

  validation {
    condition     = var.trusted_principal_arn != "*" && length(var.trusted_principal_arn) > 0
    error_message = "trusted_principal_arn nao pode ser vazio nem \"*\"."
  }
}
