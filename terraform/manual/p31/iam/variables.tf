variable "aws_region" {
  description = "Regiao AWS na qual os recursos serao gerenciados."
  type        = string

  validation {
    condition     = length(trimspace(var.aws_region)) > 0
    error_message = "aws_region nao pode ser vazia."
  }
}

variable "role_name" {
  description = "Nome da role IAM a ser criada."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]{1,64}$", var.role_name))
    error_message = "role_name deve conter de 1 a 64 caracteres permitidos pelo IAM."
  }
}

variable "policy_name" {
  description = "Nome da policy IAM customer-managed."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]{1,128}$", var.policy_name))
    error_message = "policy_name deve conter de 1 a 128 caracteres permitidos pelo IAM."
  }
}

variable "environment" {
  description = "Ambiente usado nas tags dos recursos."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment deve ser dev, staging ou prod."
  }
}

variable "trusted_service" {
  description = "Principal de servico AWS autorizado a assumir a role, por exemplo ec2.amazonaws.com."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]+\\.amazonaws\\.com(\\.cn)?$", var.trusted_service))
    error_message = "trusted_service deve ser um principal de servico AWS, nao um principal universal."
  }
}

variable "allowed_actions" {
  description = "Acoes IAM explicitas e sem wildcard amplo concedidas pela policy."
  type        = list(string)

  validation {
    condition = length(var.allowed_actions) > 0 && alltrue([
      for action in var.allowed_actions :
      can(regex("^[A-Za-z0-9-]+:[A-Za-z0-9]+$", action))
    ])
    error_message = "allowed_actions deve conter ao menos uma acao no formato servico:Acao, sem curingas."
  }
}

variable "allowed_resources" {
  description = "ARNs dos recursos aos quais as acoes permitidas se aplicam."
  type        = list(string)

  validation {
    condition = length(var.allowed_resources) > 0 && alltrue([
      for resource in var.allowed_resources :
      startswith(resource, "arn:") && resource != "*"
    ])
    error_message = "allowed_resources deve conter ao menos um ARN e nao pode conceder acesso ao recurso '*'."
  }
}

variable "additional_tags" {
  description = "Tags adicionais. Tags padrao de ambiente, projeto, gestao e nome sempre prevalecem."
  type        = map(string)
  default     = {}
}
