variable "aws_region" {
  description = "Regiao AWS onde os recursos serao providos."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role."
  type        = string
  default     = "app-execution-role"

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]{1,64}$", var.role_name))
    error_message = "role_name deve ter entre 1 e 64 caracteres validos para nomes de IAM Role (letras, numeros e + = , . @ _ -)."
  }
}

variable "policy_name" {
  description = "Nome da IAM Policy gerenciada anexada a role."
  type        = string
  default     = "app-execution-policy"

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]{1,128}$", var.policy_name))
    error_message = "policy_name deve ter entre 1 e 128 caracteres validos para nomes de IAM Policy (letras, numeros e + = , . @ _ -)."
  }
}

variable "path" {
  description = "Path aplicado a role e a policy."
  type        = string
  default     = "/"
}

variable "description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "IAM role gerenciada via Terraform, com policy dedicada anexada."
}

variable "assume_role_principal_type" {
  description = "Tipo do principal de confianca no trust policy (Service, AWS, Federated ou CanonicalUser)."
  type        = string
  default     = "Service"

  validation {
    condition     = contains(["Service", "AWS", "Federated", "CanonicalUser"], var.assume_role_principal_type)
    error_message = "assume_role_principal_type deve ser um de: Service, AWS, Federated, CanonicalUser."
  }
}

variable "assume_role_principal_identifiers" {
  description = "Identificadores do principal de confianca (ex.: [\"lambda.amazonaws.com\"] ou ARNs de conta/role). Nao use \"*\"."
  type        = list(string)
  default     = ["lambda.amazonaws.com"]

  validation {
    condition     = length(var.assume_role_principal_identifiers) > 0 && !contains(var.assume_role_principal_identifiers, "*")
    error_message = "assume_role_principal_identifiers nao pode ser vazio nem conter o wildcard \"*\"."
  }
}

variable "assume_role_external_id" {
  description = "External ID opcional exigido no assume role, recomendado para principals de outras contas."
  type        = string
  default     = null
}

variable "max_session_duration" {
  description = "Duracao maxima da sessao assumida, em segundos (entre 3600 e 43200)."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "force_detach_policies" {
  description = "Se true, forca o desanexo de policies ao destruir a role."
  type        = bool
  default     = true
}

variable "permissions_boundary_arn" {
  description = "ARN opcional de uma permissions boundary a ser aplicada a role."
  type        = string
  default     = null
}

variable "policy_statements" {
  description = "Lista de statements IAM (sid, effect, actions, resources) que compoem a policy anexada a role. Evite \"*\" em actions e resources sempre que possivel."
  type = list(object({
    sid       = string
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))

  default = [
    {
      sid    = "AllowCloudWatchLogsWrite"
      effect = "Allow"
      actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      resources = ["arn:aws:logs:*:*:log-group:/aws/lambda/*:*"]
    }
  ]

  validation {
    condition     = length(var.policy_statements) > 0 && alltrue([for s in var.policy_statements : contains(["Allow", "Deny"], s.effect)])
    error_message = "policy_statements deve conter ao menos um statement e cada effect deve ser \"Allow\" ou \"Deny\"."
  }
}

variable "tags" {
  description = "Tags adicionais aplicadas a role e a policy."
  type        = map(string)
  default     = {}
}
