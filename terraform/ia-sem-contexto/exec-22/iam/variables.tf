variable "aws_region" {
  description = "Regiao AWS onde os recursos IAM serao avaliados (IAM e global, mas o provider exige uma regiao)."
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

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "Role gerenciada via Terraform com permissoes minimas necessarias."
}

variable "role_path" {
  description = "Path da IAM Role e da IAM Policy."
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

variable "permissions_boundary_arn" {
  description = "ARN opcional de uma policy a ser usada como permissions boundary da role."
  type        = string
  default     = null
}

variable "force_detach_policies" {
  description = "Se true, forca o desanexamento de policies ao destruir a role."
  type        = bool
  default     = false
}

variable "trusted_principal_arn" {
  description = "ARN do principal (conta, role ou usuario) autorizado a assumir esta role. Nao pode ser \"*\"."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && length(var.trusted_principal_arn) > 0
    error_message = "trusted_principal_arn nao pode ser vazio ou \"*\". Especifique um ARN de conta, role ou usuario especifico."
  }
}

variable "external_id" {
  description = "External ID opcional exigido na trust policy para mitigar o problema do confused deputy em cenarios cross-account."
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

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy gerenciada via Terraform com acoes e recursos explicitamente delimitados."
}

variable "policy_statements" {
  description = "Lista de statements da IAM Policy. Cada statement deve declarar acoes e recursos especificos; o uso de acao \"*\" (administrativa total) e bloqueado."
  type = list(object({
    sid       = string
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))

  default = [
    {
      sid       = "AllowReadOnlyS3Access"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]
    }
  ]

  validation {
    condition     = alltrue([for s in var.policy_statements : contains(["Allow", "Deny"], s.effect)])
    error_message = "O campo effect de cada statement deve ser \"Allow\" ou \"Deny\"."
  }

  validation {
    condition     = alltrue([for s in var.policy_statements : !contains(s.actions, "*")])
    error_message = "Nao e permitido usar a acao \"*\" (administrativa total) em nenhum statement."
  }

  validation {
    condition     = alltrue([for s in var.policy_statements : length(s.actions) > 0 && length(s.resources) > 0])
    error_message = "Cada statement deve declarar ao menos uma acao e um recurso."
  }
}

variable "tags" {
  description = "Tags a serem aplicadas a role e a policy."
  type        = map(string)
  default     = {}
}
