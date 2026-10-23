variable "environment" {
  description = "Ambiente de implantação"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser dev, hml ou prd."
  }
}

variable "region" {
  description = "Região AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags extras aplicadas a todos os recursos"
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Nome da policy IAM com as permissões concedidas"
  type        = string
}

variable "role_name" {
  description = "Nome da role IAM que receberá a policy"
  type        = string
}

variable "trusted_principal_arn" {
  description = "ARN do único principal autorizado a assumir a role"
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*"
    error_message = "O trusted_principal_arn não pode ser \"*\"; informe um ARN específico."
  }
}

variable "allowed_actions" {
  description = "Lista de ações IAM permitidas pela policy"
  type        = list(string)

  validation {
    condition     = alltrue([for a in var.allowed_actions : a != "*"])
    error_message = "Não é permitido usar \"*\" em allowed_actions; liste as ações específicas."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs dos recursos onde as ações são permitidas"
  type        = list(string)

  validation {
    condition     = alltrue([for r in var.allowed_resources : r != "*"])
    error_message = "Não é permitido usar \"*\" em allowed_resources; liste os ARNs específicos."
  }
}
