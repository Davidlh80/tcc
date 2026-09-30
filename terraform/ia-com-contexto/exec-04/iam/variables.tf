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
  description = "Nome do sistema ou aplicacao proprietaria do recurso, usado na nomenclatura padronizada."

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  type        = string
  description = "Regiao AWS onde os recursos IAM serao provisionados."

  validation {
    condition     = length(trimspace(var.region)) > 0
    error_message = "O valor de region nao pode ser vazio."
  }
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  default     = {}
}

variable "policy_name" {
  type        = string
  description = "Finalidade/identificador da policy IAM, usado para compor o nome padronizado da policy e da role."

  validation {
    condition     = length(trimspace(var.policy_name)) > 0
    error_message = "O valor de policy_name nao pode ser vazio."
  }
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de actions IAM permitidas (Effect Allow) na policy. Nao pode conter apenas o valor \"*\" combinado com allowed_resources igual a [\"*\"]."

  validation {
    condition     = length(var.allowed_actions) > 0 && !contains(var.allowed_actions, "")
    error_message = "allowed_actions deve conter ao menos uma action valida e nao pode conter strings vazias."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos aos quais as actions permitidas se aplicam."

  validation {
    condition     = length(var.allowed_resources) > 0 && !contains(var.allowed_resources, "")
    error_message = "allowed_resources deve conter ao menos um ARN valido e nao pode conter strings vazias."
  }
}

variable "trusted_principal_arn" {
  type        = string
  description = "ARN do principal (usuario, role ou conta) autorizado a assumir esta role via sts:AssumeRole. Nao pode ser \"*\"."

  validation {
    condition     = var.trusted_principal_arn != "*" && length(trimspace(var.trusted_principal_arn)) > 0
    error_message = "trusted_principal_arn deve ser um ARN especifico e nao pode ser \"*\" nem vazio."
  }
}
