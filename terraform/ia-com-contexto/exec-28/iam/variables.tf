variable "environment" {
  type        = string
  description = "Ambiente de implantacao do recurso (dev, hml ou prd)."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema ou aplicacao associado ao recurso, usado na composicao do nome padronizado."

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
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  default     = {}
}

variable "policy_name" {
  type        = string
  description = "Finalidade da IAM Policy/Role, usada na composicao do nome padronizado (ex.: readonly, deploy)."

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "O valor de policy_name nao pode ser vazio."
  }
}

variable "trusted_principal_arn" {
  type        = string
  description = "ARN do principal (usuario, role ou conta) autorizado a assumir a IAM Role via trust policy. Nao pode ser '*'."

  validation {
    condition     = var.trusted_principal_arn != "*" && length(var.trusted_principal_arn) > 0
    error_message = "trusted_principal_arn nao pode ser vazio nem utilizar o wildcard '*'."
  }
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de acoes IAM permitidas (Effect = Allow) na policy. Nao deve conter '*' combinado com allowed_resources contendo '*'."

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma acao."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos aos quais as acoes permitidas se aplicam. Nao deve conter '*' combinado com allowed_actions contendo '*'."

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }
}
