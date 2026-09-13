variable "environment" {
  type        = string
  description = "Ambiente de implantação do recurso."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Identificador do sistema/aplicação dono do recurso, usado na composição do nome padronizado."

  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.system))
    error_message = "system deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "region" {
  type        = string
  description = "Região AWS onde o provider será configurado."
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais a serem mescladas com as tags obrigatórias da organização."
  default     = {}
}

variable "policy_name" {
  type        = string
  description = "Finalidade da IAM Policy, usada na composição do nome padronizado (ex.: readonly, deploy)."

  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.policy_name))
    error_message = "policy_name deve conter apenas letras minúsculas, números e hífens, sem espaços ou caracteres especiais."
  }
}

variable "policy_description" {
  type        = string
  description = "Descrição da IAM Policy."
  default     = "Managed by Terraform."
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de ações IAM permitidas na statement Allow. Não pode conter apenas \"*\" quando allowed_resources também for \"*\"."

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma ação."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs/recursos permitidos na statement Allow. Não pode conter apenas \"*\" quando allowed_actions também for \"*\"."

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }
}
