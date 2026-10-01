variable "environment" {
  description = "Ambiente de implantacao do recurso (dev, hml ou prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos seguintes valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema/aplicacao dono do recurso, usado no padrao de nomenclatura."
  type        = string

  validation {
    condition     = length(var.system) > 0
    error_message = "system nao pode ser uma string vazia."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string

  validation {
    condition     = length(var.region) > 0
    error_message = "region nao pode ser uma string vazia."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da policy/role, usada no padrao de nomenclatura <ambiente>-<sistema>-<recurso>-<finalidade> (ex.: readonly, deploy)."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "policy_name nao pode ser uma string vazia."
  }
}

variable "allowed_actions" {
  description = "Lista de IAM actions permitidas na policy (Effect = Allow). Nao pode conter \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0 && !contains(var.allowed_actions, "*")
    error_message = "allowed_actions deve conter ao menos uma action e nao pode conter \"*\"."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos permitidos na policy (Effect = Allow). Nao pode conter \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0 && !contains(var.allowed_resources, "*")
    error_message = "allowed_resources deve conter ao menos um recurso e nao pode conter \"*\"."
  }
}

variable "trust_principal_arn" {
  description = "ARN do principal (usuario, role ou conta) autorizado a assumir a role via sts:AssumeRole. Nao pode ser \"*\"."
  type        = string

  validation {
    condition     = var.trust_principal_arn != "*" && length(var.trust_principal_arn) > 0
    error_message = "trust_principal_arn deve ser um ARN especifico e nao pode ser \"*\"."
  }
}
