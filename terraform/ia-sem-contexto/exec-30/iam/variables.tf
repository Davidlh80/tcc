variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string

  validation {
    condition     = length(var.role_name) > 0
    error_message = "role_name não pode ser vazio."
  }
}

variable "role_path" {
  description = "Path aplicado à IAM Role e à IAM Policy."
  type        = string
  default     = "/"
}

variable "role_description" {
  description = "Descrição da IAM Role."
  type        = string
  default     = "Role gerenciada via Terraform com policy de permissões escopadas."
}

variable "max_session_duration" {
  description = "Duração máxima (em segundos) da sessão assumida via sts:AssumeRole."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "trusted_principal_arns" {
  description = "Lista de ARNs IAM (conta root, usuário ou role) autorizados a assumir a role via trust policy. Não é permitido usar \"*\" ou qualquer valor que não seja um ARN IAM válido."
  type        = list(string)

  validation {
    condition     = length(var.trusted_principal_arns) > 0
    error_message = "trusted_principal_arns deve conter ao menos um principal."
  }

  validation {
    condition = alltrue([
      for arn in var.trusted_principal_arns :
      can(regex("^arn:aws:iam::\\d{12}:(root|user/.+|role/.+)$", arn))
    ])
    error_message = "Cada item de trusted_principal_arns deve ser um ARN IAM válido (conta root, user/ ou role/), sem uso de \"*\"."
  }
}

variable "external_id" {
  description = "ExternalId opcional exigido na condition da trust policy para mitigar o problema do confused deputy em cenários cross-account."
  type        = string
  default     = null
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada e anexada à role."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "policy_name não pode ser vazio."
  }
}

variable "policy_description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "Policy gerenciada via Terraform com permissões de menor privilégio possível."
}

variable "policy_actions" {
  description = "Lista de actions IAM permitidas pela policy. Não é permitido usar a action \"*\" (equivalente a permissão administrativa total). Prefira actions específicas em vez de wildcards amplos como \"service:*\"."
  type        = list(string)

  validation {
    condition     = length(var.policy_actions) > 0 && !contains(var.policy_actions, "*")
    error_message = "policy_actions deve conter ao menos uma action e não pode incluir \"*\"."
  }
}

variable "policy_resources" {
  description = "Lista de ARNs de recursos aos quais as actions se aplicam. Evite \"*\" sempre que o serviço permitir escopo por ARN específico."
  type        = list(string)

  validation {
    condition     = length(var.policy_resources) > 0
    error_message = "policy_resources deve conter ao menos um recurso."
  }
}

variable "tags" {
  description = "Tags aplicadas à IAM Role e à IAM Policy."
  type        = map(string)
  default     = {}
}
