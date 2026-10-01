variable "environment" {
  description = "Ambiente de implantacao do recurso (dev, hml ou prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou projeto ao qual o recurso pertence, usado na composicao do nome padronizado."
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
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias definidas pela organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da IAM Policy/Role, utilizada na composicao do nome padronizado (ex.: readonly, deploy)."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "O valor de policy_name nao pode ser vazio."
  }
}

variable "allowed_actions" {
  description = "Lista de actions IAM permitidas na policy (Effect: Allow). Nao pode conter \"*\" simultaneamente com allowed_resources = [\"*\"]."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "Informe ao menos uma action em allowed_actions."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs/recursos permitidos na policy (Effect: Allow). Nao pode conter \"*\" simultaneamente com allowed_actions = [\"*\"]."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "Informe ao menos um recurso em allowed_resources."
  }
}

variable "trusted_principal_arn" {
  description = "ARN (ou principal de servico AWS) autorizado a assumir a IAM Role via trust policy. Nao pode ser \"*\"."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && length(var.trusted_principal_arn) > 0
    error_message = "trusted_principal_arn nao pode ser vazio nem \"*\"; informe um ARN ou principal de servico especifico."
  }
}
