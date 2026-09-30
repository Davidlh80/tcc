variable "region" {
  description = "Regiao AWS usada pelo provider. IAM e um servico global, a regiao afeta apenas o endpoint da API."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string

  validation {
    condition     = length(var.role_name) > 0 && length(var.role_name) <= 64
    error_message = "role_name deve ter entre 1 e 64 caracteres."
  }
}

variable "role_path" {
  description = "Path da IAM Role."
  type        = string
  default     = "/"
}

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "IAM Role gerenciada via Terraform."
}

variable "max_session_duration" {
  description = "Duracao maxima (em segundos) de uma sessao assumida com esta role."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "force_detach_policies" {
  description = "Se true, forca o desanexamento de policies ao destruir a role."
  type        = bool
  default     = false
}

variable "permissions_boundary_arn" {
  description = "ARN de uma policy a ser usada como permissions boundary da role. Deixe null para nao aplicar boundary."
  type        = string
  default     = null
}

variable "trusted_service_principals" {
  description = "Lista de service principals da AWS (ex: lambda.amazonaws.com) autorizados a assumir a role."
  type        = list(string)
  default     = ["lambda.amazonaws.com"]
}

variable "trusted_aws_principals" {
  description = "Lista de ARNs de contas/roles/usuarios AWS autorizados a assumir a role. Use com cautela em cenarios cross-account."
  type        = list(string)
  default     = []
}

variable "external_id" {
  description = "External ID exigido no assume role, recomendado para cenarios cross-account. Deixe null para nao exigir."
  type        = string
  default     = null
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada e anexada a role."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128
    error_message = "policy_name deve ter entre 1 e 128 caracteres."
  }
}

variable "policy_path" {
  description = "Path da IAM Policy."
  type        = string
  default     = "/"
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "IAM Policy gerenciada via Terraform, anexada a uma IAM Role especifica."
}

variable "policy_statements" {
  description = "Lista de statements da IAM Policy. Nao utilize '*' em actions ou resources; prefira acoes e ARNs especificos (principio do menor privilegio)."
  type = list(object({
    sid    = optional(string)
    effect = optional(string, "Allow")
    actions   = list(string)
    resources = list(string)
    conditions = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })), [])
  }))

  default = [
    {
      sid       = "AllowS3ReadOnlyExample"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = [
        "arn:aws:s3:::REPLACE_WITH_BUCKET_NAME",
        "arn:aws:s3:::REPLACE_WITH_BUCKET_NAME/*"
      ]
      conditions = []
    }
  ]

  validation {
    condition     = length(var.policy_statements) > 0
    error_message = "policy_statements deve conter ao menos um statement."
  }

  validation {
    condition     = alltrue([for s in var.policy_statements : contains(["Allow", "Deny"], s.effect)])
    error_message = "O campo effect de cada statement deve ser 'Allow' ou 'Deny'."
  }

  validation {
    condition     = alltrue([for s in var.policy_statements : !contains(s.actions, "*")])
    error_message = "Nao e permitido usar '*' em actions. Especifique as acoes necessarias."
  }

  validation {
    condition     = alltrue([for s in var.policy_statements : !contains(s.resources, "*")])
    error_message = "Nao e permitido usar '*' em resources. Especifique os ARNs necessarios."
  }
}

variable "tags" {
  description = "Tags aplicadas a IAM Role e a IAM Policy."
  type        = map(string)
  default     = {}
}
