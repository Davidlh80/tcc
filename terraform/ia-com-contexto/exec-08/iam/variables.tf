variable "environment" {
  description = "Ambiente de implantacao do recurso (dev, hml ou prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser 'dev', 'hml' ou 'prd'."
  }
}

variable "system" {
  description = "Nome do sistema ou aplicacao ao qual o recurso pertence."
  type        = string

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS utilizada pelo provider."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da policy, usada para compor o nome padronizado do recurso (ex.: readonly, deploy, logging)."
  type        = string

  validation {
    condition     = length(trimspace(var.policy_name)) > 0
    error_message = "O valor de policy_name nao pode ser vazio."
  }
}

variable "trusted_principal_arn" {
  description = "ARN do principal (usuario, role ou conta) autorizado a assumir a IAM Role. Nao pode ser um wildcard."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws:iam::\\d{12}:(root|user/.+|role/.+)$", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM valido (root, user ou role) e nao pode ser \"*\"."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas na statement Allow da policy."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma acao."
  }
}

variable "allowed_resources" {
  description = "Lista de recursos (ARNs) aos quais as acoes permitidas se aplicam."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }
}
