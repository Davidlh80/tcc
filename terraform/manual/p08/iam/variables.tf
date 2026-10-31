variable "policy_name" {
  description = "Nome padronizado da policy IAM."
  type        = string
}

variable "role_name" {
  description = "Nome padronizado da role IAM."
  type        = string
}

variable "environment" {
  description = "Ambiente de implantação."
  type        = string
}

variable "trusted_principal_type" {
  description = "Tipo do principal de confiança; por exemplo Service ou AWS."
  type        = string
  default     = "Service"

  validation {
    condition     = contains(["Service", "AWS", "Federated"], var.trusted_principal_type)
    error_message = "Use Service, AWS ou Federated."
  }
}

variable "trusted_principal_identifiers" {
  description = "Identificadores explícitos e restritos do principal confiável."
  type        = list(string)

  validation {
    condition     = length(var.trusted_principal_identifiers) > 0 && !contains(var.trusted_principal_identifiers, "*")
    error_message = "Informe pelo menos um principal específico; wildcard isolado não é permitido."
  }
}

variable "allowed_actions" {
  description = "Ações mínimas necessárias para a workload."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0 && !contains(var.allowed_actions, "*")
    error_message = "Informe ações explícitas; '*' não é permitido como ação."
  }
}

variable "allowed_resources" {
  description = "ARNs específicos dos recursos autorizados."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0 && !contains(var.allowed_resources, "*")
    error_message = "Informe recursos específicos; '*' não é permitido como recurso isolado."
  }
}

variable "policy_description" {
  description = "Descrição da policy IAM."
  type        = string
  default     = "Policy gerenciada pelo Terraform"
}

variable "role_description" {
  description = "Descrição da role IAM."
  type        = string
  default     = "Role gerenciada pelo Terraform"
}

variable "tags" {
  description = "Tags adicionais."
  type        = map(string)
  default     = {}
}
variable "aws_region" {
  description = "Região AWS para o provider."
  type        = string
  default     = "us-east-1"
}
