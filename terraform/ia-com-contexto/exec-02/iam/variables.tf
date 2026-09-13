variable "environment" {
  description = "Ambiente de implantacao (dev, hml ou prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/produto, usado na nomenclatura padronizada dos recursos."
  type        = string

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(var.region) > 0
    error_message = "O valor de region nao pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da IAM Policy, utilizada na composicao do nome padronizado (ex.: readonly, deploy)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.policy_name))
    error_message = "O valor de policy_name deve conter apenas letras minusculas, numeros e hifens (ex.: readonly, deploy-app)."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Managed by Terraform."
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas (Effect Allow). Nao deve conter apenas \"*\" combinado com allowed_resources igual a [\"*\"]."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma acao."
  }

  validation {
    condition     = alltrue([for a in var.allowed_actions : a != ""])
    error_message = "allowed_actions nao pode conter strings vazias."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos aos quais as acoes permitidas se aplicam."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }

  validation {
    condition     = alltrue([for r in var.allowed_resources : r != ""])
    error_message = "allowed_resources nao pode conter strings vazias."
  }
}
