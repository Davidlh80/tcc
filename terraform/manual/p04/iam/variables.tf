variable "region" {
  description = "Região AWS utilizada pelo provider."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Ambiente do recurso (dev, hml ou prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O ambiente deve ser dev, hml ou prd."
  }
}

variable "policy_name" {
  description = "Nome da policy IAM."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]{1,128}$", var.policy_name))
    error_message = "O nome da policy deve ter até 128 caracteres válidos para IAM."
  }
}

variable "role_name" {
  description = "Nome da role IAM."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]{1,64}$", var.role_name))
    error_message = "O nome da role deve ter até 64 caracteres válidos para IAM."
  }
}

variable "trusted_principal_type" {
  description = "Tipo do principal autorizado a assumir a role: AWS (conta/role/usuário) ou Service (serviço AWS)."
  type        = string
  default     = "AWS"

  validation {
    condition     = contains(["AWS", "Service"], var.trusted_principal_type)
    error_message = "O tipo do principal deve ser AWS ou Service."
  }
}

variable "trusted_principal_arn" {
  description = "Principal autorizado a assumir a role: um ARN (tipo AWS) ou um serviço como ec2.amazonaws.com (tipo Service)."
  type        = string

  validation {
    condition     = !strcontains(var.trusted_principal_arn, "*")
    error_message = "O principal de confiança não pode conter wildcard (*)."
  }
}

variable "allowed_actions" {
  description = "Lista de ações IAM permitidas pela policy (ex.: s3:GetObject)."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0 && alltrue([for action in var.allowed_actions : action != "*" && can(regex("^[a-z0-9-]+:[A-Za-z0-9*]+$", action))])
    error_message = "Informe ao menos uma ação no formato servico:Acao; o wildcard total (*) não é permitido."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos nos quais as ações são permitidas."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0 && alltrue([for resource in var.allowed_resources : resource != "*"])
    error_message = "Informe ao menos um ARN de recurso; o wildcard total (*) não é permitido."
  }
}

variable "additional_tags" {
  description = "Tags adicionais aplicadas à policy e à role, somadas às tags obrigatórias."
  type        = map(string)
  default     = {}
}
