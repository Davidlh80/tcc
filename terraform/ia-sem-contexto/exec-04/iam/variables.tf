variable "aws_region" {
  description = "Regiao AWS utilizada pelo provider."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string
  default     = "app-restricted-role"
}

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "Role com permissoes restritas, assumida apenas por principals configurados explicitamente."
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada e anexada a role."
  type        = string
  default     = "app-restricted-policy"
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy com acoes e recursos restritos, sem permissoes administrativas amplas."
}

variable "path" {
  description = "Path utilizado tanto para a IAM Role quanto para a IAM Policy."
  type        = string
  default     = "/"
}

variable "max_session_duration" {
  description = "Duracao maxima (em segundos) de uma sessao assumida para esta role."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "trusted_principal_arns" {
  description = "Lista de ARNs de principals (contas, roles ou users) autorizados a assumir a role. Nao e permitido usar \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.trusted_principal_arns) > 0
    error_message = "trusted_principal_arns deve conter ao menos um ARN."
  }

  validation {
    condition     = !contains(var.trusted_principal_arns, "*")
    error_message = "trusted_principal_arns nao pode conter \"*\"; especifique principals concretos."
  }

  validation {
    condition = alltrue([
      for arn in var.trusted_principal_arns :
      can(regex("^arn:aws:iam::[0-9]{12}:(root|(user|role)/.+)$", arn))
    ])
    error_message = "Cada entrada de trusted_principal_arns deve ser um ARN IAM valido, ex: arn:aws:iam::123456789012:role/nome-da-role."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas na policy. Nao e permitido o wildcard total \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma acao."
  }

  validation {
    condition     = alltrue([for action in var.allowed_actions : action != "*"])
    error_message = "allowed_actions nao pode conter o wildcard total \"*\" (permissao administrativa irrestrita)."
  }

  validation {
    condition     = alltrue([for action in var.allowed_actions : action != "iam:*"])
    error_message = "allowed_actions nao pode conter \"iam:*\"; evite conceder administracao total de IAM."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs (ou padroes de ARN) de recursos aos quais as allowed_actions se aplicam."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }
}

variable "tags" {
  description = "Tags aplicadas a role e a policy."
  type        = map(string)
  default     = {}
}
