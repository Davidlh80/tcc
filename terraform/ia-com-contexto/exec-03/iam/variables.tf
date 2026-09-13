variable "environment" {
  description = "Ambiente de implantacao do recurso."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema/produto ao qual o recurso pertence."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.system))
    error_message = "O valor de system deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos serao criados."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas as tags obrigatorias do recurso."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da IAM Policy, utilizada para compor o nome padronizado do recurso (ex.: readonly)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.policy_name))
    error_message = "O valor de policy_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Gerenciada via Terraform."
}

variable "allowed_actions" {
  description = "Lista de actions IAM permitidas na statement Allow da policy."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma action."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos permitidos na statement Allow da policy."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um resource."
  }
}
