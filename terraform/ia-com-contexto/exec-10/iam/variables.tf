variable "environment" {
  type        = string
  description = "Ambiente de implantacao (dev, hml ou prd)."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema/aplicacao dono do recurso, usado na composicao do nome padronizado."

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  type        = string
  description = "Regiao AWS onde os recursos serao provisionados."

  validation {
    condition     = length(var.region) > 0
    error_message = "O valor de region nao pode ser vazio."
  }
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais a serem mescladas as tags obrigatorias da organizacao."
  default     = {}
}

variable "policy_name" {
  type        = string
  description = "Finalidade da IAM Policy, usada na composicao do nome padronizado (ex.: readonly, deploy)."

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "O valor de policy_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "policy_description" {
  type        = string
  description = "Descricao da IAM Policy."
  default     = "Managed by Terraform."
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de acoes IAM permitidas na statement Allow. Nao pode conter \"*\" quando allowed_resources tambem contiver \"*\"."

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma acao."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos permitidos na statement Allow. Nao pode conter \"*\" quando allowed_actions tambem contiver \"*\"."

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }
}
