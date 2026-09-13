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
  description = "Nome do sistema/produto ao qual o recurso pertence, usado na nomenclatura padronizada."

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
  description = "Tags adicionais mescladas as tags obrigatorias do padrao organizacional."
  default     = {}
}

variable "policy_name" {
  type        = string
  description = "Finalidade da IAM Policy, usada para compor o nome padronizado (ex.: readonly, deploy)."

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "O valor de policy_name nao pode ser vazio."
  }
}

variable "policy_description" {
  type        = string
  description = "Descricao funcional da IAM Policy."
  default     = "Policy gerenciada via Terraform seguindo o padrao organizacional de menor privilegio."
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de actions do IAM permitidas na statement Allow da policy."

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "Informe ao menos uma action em allowed_actions."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos permitidos na statement Allow da policy."

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "Informe ao menos um resource em allowed_resources."
  }

  validation {
    condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
    error_message = "Nao e permitido combinar Action \"*\" com Resource \"*\" na mesma policy."
  }
}
