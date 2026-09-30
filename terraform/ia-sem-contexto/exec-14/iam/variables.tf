variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string
  default     = "app-role"

  validation {
    condition     = length(var.role_name) > 0 && length(var.role_name) <= 64
    error_message = "role_name deve ter entre 1 e 64 caracteres."
  }
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada e anexada a role."
  type        = string
  default     = "app-policy"

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128
    error_message = "policy_name deve ter entre 1 e 128 caracteres."
  }
}

variable "path" {
  description = "Path usado tanto para a IAM Role quanto para a IAM Policy."
  type        = string
  default     = "/"
}

variable "assume_role_service_principals" {
  description = "Lista de service principals da AWS autorizados a assumir a role (ex.: ec2.amazonaws.com, lambda.amazonaws.com)."
  type        = list(string)
  default     = ["ec2.amazonaws.com"]

  validation {
    condition     = length(var.assume_role_service_principals) > 0
    error_message = "Informe ao menos um service principal autorizado a assumir a role."
  }

  validation {
    condition     = !contains(var.assume_role_service_principals, "*")
    error_message = "Nao e permitido usar '*' como principal de confianca."
  }
}

variable "assume_role_external_id" {
  description = "External ID opcional exigido na AssumeRole (recomendado para cenarios cross-account). Deixe null para nao exigir."
  type        = string
  default     = null
}

variable "max_session_duration" {
  description = "Duracao maxima (em segundos) da sessao assumida via AssumeRole."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "permissions_boundary_arn" {
  description = "ARN de uma permissions boundary opcional a ser aplicada na role."
  type        = string
  default     = null
}

variable "force_detach_policies" {
  description = "Se true, forca o desanexo de policies ao destruir a role."
  type        = bool
  default     = true
}

variable "policy_statements" {
  description = "Lista de statements (sid, effect, actions, resources) que compoem a IAM Policy anexada a role. Nao permite resource '*'."
  type = list(object({
    sid       = string
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))

  default = [
    {
      sid       = "AllowCloudWatchLogsWrite"
      effect    = "Allow"
      actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
      resources = ["arn:aws:logs:*:*:log-group:/app/example:*"]
    }
  ]

  validation {
    condition     = length(var.policy_statements) > 0
    error_message = "Informe ao menos um statement para a policy."
  }

  validation {
    condition     = alltrue([for s in var.policy_statements : contains(["Allow", "Deny"], s.effect)])
    error_message = "O campo 'effect' de cada statement deve ser 'Allow' ou 'Deny'."
  }

  validation {
    condition     = alltrue([for s in var.policy_statements : !contains(s.resources, "*")])
    error_message = "Nao e permitido usar '*' como resource; escope os recursos explicitamente."
  }
}

variable "tags" {
  description = "Tags aplicadas a role e a policy."
  type        = map(string)
  default     = {}
}
