variable "region" {
  type        = string
  description = "Regiao AWS onde os recursos serao provisionados."
  default     = "us-east-1"
}

variable "role_name" {
  type        = string
  description = "Nome da IAM Role a ser criada."

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,64}$", var.role_name))
    error_message = "role_name deve ter entre 1 e 64 caracteres validos para nomes de IAM Role (letras, numeros e + = , . @ -)."
  }
}

variable "role_description" {
  type        = string
  description = "Descricao da IAM Role."
  default     = "Role gerenciada via Terraform com politica de minimo privilegio anexada."
}

variable "iam_path" {
  type        = string
  description = "Path usado tanto na IAM Role quanto na IAM Policy."
  default     = "/"
}

variable "max_session_duration" {
  type        = number
  description = "Duracao maxima, em segundos, de uma sessao assumida via esta role."
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "force_detach_policies" {
  type        = bool
  description = "Se true, permite que o Terraform destrua a role mesmo com policies gerenciadas anexadas."
  default     = true
}

variable "permissions_boundary_arn" {
  type        = string
  description = "ARN de uma policy a ser usada como permissions boundary da role. Use null para nao definir boundary."
  default     = null
  nullable    = true

  validation {
    condition     = var.permissions_boundary_arn == null || can(regex("^arn:aws:iam::\\d{12}:policy/.+$", var.permissions_boundary_arn))
    error_message = "permissions_boundary_arn deve ser null ou um ARN valido de IAM Policy."
  }
}

variable "trusted_service" {
  type        = string
  description = "Principal de servico AWS (ex.: ec2.amazonaws.com, lambda.amazonaws.com) que podera assumir a role."
  default     = "ec2.amazonaws.com"

  validation {
    condition     = can(regex("^[a-zA-Z0-9.-]+\\.amazonaws\\.com$", var.trusted_service))
    error_message = "trusted_service deve ser um principal de servico AWS valido, ex.: ec2.amazonaws.com."
  }
}

variable "trusted_account_ids" {
  type        = list(string)
  description = "Lista opcional de IDs de contas AWS (12 digitos) que poderao assumir a role via seus root principals, alem do trusted_service."
  default     = []

  validation {
    condition     = alltrue([for account_id in var.trusted_account_ids : can(regex("^\\d{12}$", account_id))])
    error_message = "Cada item de trusted_account_ids deve ser um Account ID AWS valido com 12 digitos."
  }
}

variable "external_id" {
  type        = string
  description = "External ID exigido no AssumeRole para os principals de conta definidos em trusted_account_ids. Use null para nao exigir."
  default     = null
  nullable    = true
}

variable "policy_name" {
  type        = string
  description = "Nome da IAM Policy que sera anexada a role."

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,128}$", var.policy_name))
    error_message = "policy_name deve ter entre 1 e 128 caracteres validos para nomes de IAM Policy (letras, numeros e + = , . @ -)."
  }
}

variable "policy_description" {
  type        = string
  description = "Descricao da IAM Policy."
  default     = "Policy de minimo privilegio gerenciada via Terraform."
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista explicita de actions IAM permitidas na policy. Wildcard total (\"*\") nao e permitido."

  validation {
    condition     = length(var.allowed_actions) > 0 && !contains(var.allowed_actions, "*")
    error_message = "allowed_actions deve conter ao menos uma action explicita e nao pode incluir o wildcard total \"*\"."
  }
}

variable "resource_arns" {
  type        = list(string)
  description = "Lista explicita de ARNs de recursos aos quais as allowed_actions se aplicam. Wildcard total (\"*\") nao e permitido."

  validation {
    condition     = length(var.resource_arns) > 0 && !contains(var.resource_arns, "*")
    error_message = "resource_arns deve conter ao menos um ARN explicito e nao pode incluir o wildcard total \"*\"."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas a IAM Role e a IAM Policy."
  default     = {}
}
