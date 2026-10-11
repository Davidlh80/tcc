variable "aws_region" {
  type        = string
  description = "Regiao AWS utilizada pelo provider."
  default     = "us-east-1"
}

variable "role_name" {
  type        = string
  description = "Nome da IAM Role a ser criada."

  validation {
    condition     = length(var.role_name) > 0 && length(var.role_name) <= 64
    error_message = "role_name deve ter entre 1 e 64 caracteres."
  }
}

variable "policy_name" {
  type        = string
  description = "Nome da IAM Policy a ser criada e anexada a role."

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128
    error_message = "policy_name deve ter entre 1 e 128 caracteres."
  }
}

variable "trusted_principal_arns" {
  type        = list(string)
  description = "Lista de ARNs de principals (contas, roles ou usuarios) autorizados a assumir a role. Nao pode conter \"*\"."

  validation {
    condition     = length(var.trusted_principal_arns) > 0 && !contains(var.trusted_principal_arns, "*")
    error_message = "trusted_principal_arns deve conter ao menos um ARN explicito e nao pode conter \"*\"."
  }
}

variable "external_id" {
  type        = string
  description = "External ID opcional exigido na trust policy para mitigar confused deputy. Deixe null para nao exigir."
  default     = null
}

variable "max_session_duration" {
  type        = number
  description = "Duracao maxima (em segundos) de uma sessao assumida da role. Entre 3600 e 43200."
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "policy_actions" {
  type        = list(string)
  description = "Lista de actions IAM permitidas pela policy. Nao pode conter o wildcard total \"*\"."
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.policy_actions) > 0 && !contains(var.policy_actions, "*")
    error_message = "policy_actions deve conter ao menos uma action e nao pode conter o wildcard total \"*\"."
  }
}

variable "policy_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos aos quais as actions se aplicam. Deve ser explicita, a menos que allow_wildcard_resources seja true."

  validation {
    condition     = length(var.policy_resources) > 0
    error_message = "policy_resources deve conter ao menos um ARN."
  }

  validation {
    condition     = var.allow_wildcard_resources || !contains(var.policy_resources, "*")
    error_message = "policy_resources nao pode conter \"*\" a menos que allow_wildcard_resources seja definido como true."
  }
}

variable "allow_wildcard_resources" {
  type        = bool
  description = "Permite explicitamente o uso de \"*\" em policy_resources. Mantenha false por padrao para evitar permissoes amplas."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas a role e a policy."
  default     = {}
}
