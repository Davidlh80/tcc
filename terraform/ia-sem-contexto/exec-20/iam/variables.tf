variable "aws_region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string
  default     = "example-app-role"

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_-]{1,64}$", var.role_name))
    error_message = "role_name deve conter de 1 a 64 caracteres validos para nomes IAM (letras, numeros e os simbolos + = , . @ _ -)."
  }
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada e anexada a role."
  type        = string
  default     = "example-app-policy"

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_-]{1,128}$", var.policy_name))
    error_message = "policy_name deve conter de 1 a 128 caracteres validos para nomes IAM."
  }
}

variable "path" {
  description = "Path IAM aplicado a role e a policy."
  type        = string
  default     = "/"
}

variable "trusted_principal_arn" {
  description = "ARN do principal (role, usuario ou conta) autorizado a assumir a role. Nao e permitido usar '*' ou um principal irrestrito."
  type        = string
  default     = "arn:aws:iam::123456789012:role/trusted-caller"

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:(role/.+|user/.+|root)$", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM valido de role, user ou root (ex.: arn:aws:iam::123456789012:role/nome). Nao e permitido '*' ou curingas."
  }
}

variable "external_id" {
  description = "External ID opcional exigido na condicao sts:ExternalId da trust policy. Deixe em branco para nao aplicar essa condicao."
  type        = string
  default     = ""
  sensitive   = true
}

variable "max_session_duration" {
  description = "Duracao maxima (em segundos) da sessao assumida pela role."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas pela policy. Nao e permitido o uso de '*' (todas as acoes)."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.allowed_actions) > 0 && !contains(var.allowed_actions, "*")
    error_message = "allowed_actions nao pode ser vazio nem conter o curinga '*'."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos aos quais as acoes sao permitidas. Nao e permitido o uso de '*' (todos os recursos)."
  type        = list(string)
  default     = ["arn:aws:s3:::example-app-bucket", "arn:aws:s3:::example-app-bucket/*"]

  validation {
    condition     = length(var.allowed_resources) > 0 && !contains(var.allowed_resources, "*")
    error_message = "allowed_resources nao pode ser vazio nem conter o curinga '*'."
  }
}

variable "tags" {
  description = "Tags aplicadas a role e a policy."
  type        = map(string)
  default     = {}
}
