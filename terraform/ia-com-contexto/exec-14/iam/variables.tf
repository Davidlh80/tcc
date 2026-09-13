variable "environment" {
  description = "Ambiente de implantacao do recurso. Deve ser um dos ambientes permitidos pela organizacao."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser \"dev\", \"hml\" ou \"prd\"."
  }
}

variable "system" {
  description = "Nome do sistema ou aplicacao ao qual o recurso pertence, utilizado na padronizacao de nomenclatura."
  type        = string

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "O valor de region deve seguir o formato de uma regiao AWS valida, por exemplo: us-east-1."
  }
}

variable "policy_name" {
  description = "Finalidade da IAM Policy, utilizada como sufixo no padrao de nomenclatura <ambiente>-<sistema>-<recurso>-<finalidade> (ex.: readonly, deploy)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "O valor de policy_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy gerenciada via Terraform seguindo o padrao organizacional de menor privilegio."
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas na statement Allow da policy. Nao pode conter \"*\" quando allowed_resources tambem contiver \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "O valor de allowed_actions deve conter ao menos uma acao."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos permitidos na statement Allow da policy. Nao pode conter \"*\" quando allowed_actions tambem contiver \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "O valor de allowed_resources deve conter ao menos um recurso."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}
