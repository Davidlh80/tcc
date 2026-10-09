variable "region" {
  description = "Regiao AWS usada pelo provider."
  type        = string
  default     = "us-east-1"
}

variable "policy_name" {
  description = "Nome da policy IAM."
  type        = string
}

variable "role_name" {
  description = "Nome da role IAM."
  type        = string
}

variable "environment" {
  description = "Ambiente do recurso: dev, hml ou prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser dev, hml ou prd."
  }
}

variable "trusted_principal_arn" {
  description = "ARN do principal que pode assumir a role (conta, role ou usuario IAM)."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-z-]*:iam::[0-9]{12}:(root|role/[A-Za-z0-9+=,.@_/-]+|user/[A-Za-z0-9+=,.@_/-]+)$", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM especifico, sem curinga."
  }
}

variable "allowed_actions" {
  description = "Acoes permitidas pela policy, no formato servico:Acao."
  type        = list(string)

  validation {
    condition = length(var.allowed_actions) > 0 && alltrue([
      for action in var.allowed_actions : can(regex("^[a-z0-9-]+:[A-Za-z]+$", action))
    ])
    error_message = "allowed_actions nao pode ser vazio nem conter curinga (ex.: * ou s3:*)."
  }
}

variable "allowed_resources" {
  description = "ARNs dos recursos liberados pela policy."
  type        = list(string)

  validation {
    condition = length(var.allowed_resources) > 0 && alltrue([
      for arn in var.allowed_resources : startswith(arn, "arn:")
    ])
    error_message = "allowed_resources deve conter apenas ARNs explicitos; * nao e aceito."
  }
}

variable "additional_tags" {
  description = "Tags extras. Nao sobrescrevem as tags obrigatorias."
  type        = map(string)
  default     = {}
}
