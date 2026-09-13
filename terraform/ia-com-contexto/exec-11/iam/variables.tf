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
  description = "Nome do sistema ou aplicacao associado ao recurso."

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  type        = string
  description = "Regiao AWS onde o provider sera configurado."
  default     = "us-east-1"
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  default     = {}
}

variable "policy_name" {
  type        = string
  description = "Finalidade da IAM Policy, usada para compor o nome completo no padrao <ambiente>-<sistema>-iam-<finalidade> (ex.: readonly, deploy)."

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "O valor de policy_name nao pode ser vazio."
  }
}

variable "description" {
  type        = string
  description = "Descricao da IAM Policy."
  default     = "Managed by Terraform."
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de acoes IAM permitidas pela policy. Nao deve conter \"*\" quando allowed_resources tambem contiver \"*\"."

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma acao."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos aos quais as acoes permitidas se aplicam. Nao deve conter \"*\" quando allowed_actions tambem contiver \"*\"."

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }
}
