variable "environment" {
  description = "Ambiente de implantacao do recurso. Deve ser dev, hml ou prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema/aplicacao ao qual o recurso pertence, usado na padronizacao de nomenclatura."
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

variable "policy_name" {
  description = "Finalidade da IAM Policy, utilizada na composicao do nome padronizado (<ambiente>-<sistema>-iam-<finalidade>)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "O valor de policy_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy gerenciada via Terraform."
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas na statement Allow. Nao pode conter \"*\" quando allowed_resources tambem contiver \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma acao."
  }
}

variable "allowed_resources" {
  description = "Lista de recursos (ARNs) aos quais as acoes permitidas se aplicam. Nao pode conter \"*\" quando allowed_actions tambem contiver \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }
}

variable "additional_tags" {
  description = "Tags adicionais para mesclar com as tags obrigatorias do padrao organizacional."
  type        = map(string)
  default     = {}
}
