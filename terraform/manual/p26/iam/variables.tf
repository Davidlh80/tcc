variable "region" {
  description = "Região AWS do provider."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Ambiente de implantação (dev, hml ou prod)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prod"], var.environment)
    error_message = "O ambiente deve ser dev, hml ou prod."
  }
}

variable "policy_name" {
  description = "Nome da IAM Policy."
  type        = string
}

variable "role_name" {
  description = "Nome da IAM Role."
  type        = string
}

variable "trusted_principal_type" {
  description = "Tipo do principal de confiança da role: Service ou AWS."
  type        = string
  default     = "Service"

  validation {
    condition     = contains(["Service", "AWS"], var.trusted_principal_type)
    error_message = "O tipo do principal deve ser Service ou AWS."
  }
}

variable "trusted_principal_identifiers" {
  description = "Principais autorizados a assumir a role (ex.: ec2.amazonaws.com ou ARN de conta/role)."
  type        = list(string)
  default     = ["ec2.amazonaws.com"]

  validation {
    condition     = length(var.trusted_principal_identifiers) > 0 && !contains(var.trusted_principal_identifiers, "*")
    error_message = "Informe ao menos um principal; \"*\" não é permitido."
  }
}

variable "allowed_actions" {
  description = "Ações IAM permitidas pela policy (ex.: s3:GetObject)."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0 && alltrue([for a in var.allowed_actions : a != "*" && !endswith(a, ":*")])
    error_message = "Informe ações específicas; \"*\" e \"servico:*\" não são permitidos."
  }
}

variable "allowed_resources" {
  description = "ARNs dos recursos sobre os quais as ações são permitidas."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0 && !contains(var.allowed_resources, "*")
    error_message = "Informe ARNs específicos; \"*\" não é permitido."
  }
}

variable "tags" {
  description = "Tags adicionais aplicadas à policy e à role."
  type        = map(string)
  default     = {}
}
