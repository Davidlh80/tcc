variable "environment" {
  type        = string
  description = "Ambiente de implantacao do recurso. Valores permitidos: dev, hml, prd."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema ou aplicacao proprietaria do recurso, utilizado na nomenclatura padronizada."

  validation {
    condition     = length(var.system) > 0
    error_message = "system nao pode ser uma string vazia."
  }
}

variable "region" {
  type        = string
  description = "Regiao AWS onde os recursos serao provisionados."
  default     = "us-east-1"
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais a serem mescladas as tags obrigatorias definidas pela organizacao."
  default     = {}
}

variable "policy_name" {
  type        = string
  description = "Finalidade da IAM Policy/Role, utilizada para compor o nome padronizado dos recursos (ex.: readonly, deploy)."

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "policy_name nao pode ser uma string vazia."
  }
}

variable "trusted_principal_arn" {
  type        = string
  description = "ARN unico do principal (IAM User, Role ou conta) autorizado a assumir a IAM Role. Nao aceita wildcard."

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws:iam::", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM valido e especifico; o uso de \"*\" nao e permitido."
  }
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de actions IAM permitidas (Effect Allow) na policy criada."

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma action."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos permitidos (Effect Allow) na policy criada."

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um ARN de recurso."
  }
}
