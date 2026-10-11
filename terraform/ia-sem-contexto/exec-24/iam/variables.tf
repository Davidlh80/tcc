variable "aws_region" {
  description = "Regiao AWS onde os recursos IAM serao avaliados pelo provider."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string
  default     = "example-app-role"
}

variable "role_path" {
  description = "Path usado tanto para a IAM Role quanto para a IAM Policy."
  type        = string
  default     = "/"
}

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "Role de aplicacao com permissoes minimas definidas por configuracao."
}

variable "policy_name" {
  description = "Nome da IAM Policy gerenciada anexada a role."
  type        = string
  default     = "example-app-policy"
}

variable "max_session_duration" {
  description = "Duracao maxima (em segundos) de uma sessao assumida da role."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "trusted_principal_arns" {
  description = "Lista de ARNs de principals (contas, roles ou usuarios) autorizados a assumir a role. Nao pode conter '*' ou ARNs de conta com wildcard."
  type        = list(string)

  validation {
    condition     = length(var.trusted_principal_arns) > 0
    error_message = "trusted_principal_arns deve conter ao menos um principal."
  }

  validation {
    condition = alltrue([
      for arn in var.trusted_principal_arns :
      arn != "*" && !can(regex("^arn:aws:iam::\\*:", arn))
    ])
    error_message = "trusted_principal_arns nao pode conter '*' nem ARNs de conta com wildcard (arn:aws:iam::*:...)."
  }
}

variable "external_id" {
  description = "ExternalId opcional exigido na trust policy para mitigar o problema do 'confused deputy'. Deixe null para nao exigir."
  type        = string
  default     = null
  sensitive   = true
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas pela policy. Nao pode conter wildcard total ('*') nem acoes administrativas amplas (ex.: 'iam:*')."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma acao."
  }

  validation {
    condition = alltrue([
      for action in var.allowed_actions :
      action != "*" && !can(regex("^[A-Za-z0-9]+:\\*$", action))
    ])
    error_message = "allowed_actions nao pode conter '*' nem wildcard de servico completo (ex.: 'iam:*', 's3:*')."
  }
}

variable "resource_arns" {
  description = "Lista de ARNs de recursos aos quais as acoes permitidas se aplicam. Nao pode conter '*'."
  type        = list(string)
  default     = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]

  validation {
    condition     = length(var.resource_arns) > 0
    error_message = "resource_arns deve conter ao menos um recurso."
  }

  validation {
    condition     = !contains(var.resource_arns, "*")
    error_message = "resource_arns nao pode conter '*'."
  }
}

variable "tags" {
  description = "Tags aplicadas a role e a policy."
  type        = map(string)
  default     = {}
}
