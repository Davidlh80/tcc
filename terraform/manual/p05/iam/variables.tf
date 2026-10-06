variable "region" {
  description = "Regiao AWS."
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
  description = "Ambiente (dev, hml ou prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O ambiente deve ser dev, hml ou prd."
  }
}

variable "trusted_principal_arn" {
  description = "ARN do principal autorizado a assumir a role (ex.: arn:aws:iam::123456789012:role/app)."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws[a-z-]*:iam::[0-9]{12}:", var.trusted_principal_arn))
    error_message = "Informe um ARN IAM especifico; '*' nao e permitido."
  }
}

variable "allowed_actions" {
  description = "Acoes permitidas pela policy."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0 && !contains(var.allowed_actions, "*")
    error_message = "Informe ao menos uma acao e nao use '*'."
  }
}

variable "allowed_resources" {
  description = "ARNs dos recursos aos quais as acoes se aplicam."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0 && !contains(var.allowed_resources, "*")
    error_message = "Informe ao menos um recurso e nao use '*'."
  }
}

variable "additional_tags" {
  description = "Tags adicionais."
  type        = map(string)
  default     = {}
}
