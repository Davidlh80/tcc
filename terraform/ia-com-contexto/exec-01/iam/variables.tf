variable "environment" {
  description = "Ambiente de implantacao (dev, hml ou prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou aplicacao, utilizado na composicao do nome dos recursos."
  type        = string
  default     = "tcc"
}

variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da IAM Policy, utilizada na composicao do nome padrao <ambiente>-<sistema>-iam-<finalidade>."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "O valor de policy_name nao pode ser vazio."
  }
}

variable "role_name" {
  description = "Finalidade da IAM Role, utilizada na composicao do nome padrao <ambiente>-<sistema>-iam-<finalidade>."
  type        = string

  validation {
    condition     = length(var.role_name) > 0
    error_message = "O valor de role_name nao pode ser vazio."
  }
}

variable "trusted_principal_arn" {
  description = "ARN do principal (usuario, role ou conta) autorizado a assumir a IAM Role. Nao e permitido utilizar \"*\"."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && length(var.trusted_principal_arn) > 0
    error_message = "trusted_principal_arn nao pode ser vazio ou \"*\"; informe um principal especifico."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas na policy (Effect: Allow)."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma acao."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos permitidos na policy (Effect: Allow)."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }
}
