variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string
  default     = "example-app-role"

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,64}$", var.role_name))
    error_message = "role_name deve conter entre 1 e 64 caracteres validos para nomes de IAM Role (letras, numeros e + = , . @ - _)."
  }
}

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "Role gerenciada via Terraform com permissoes restritas."
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada e anexada a role."
  type        = string
  default     = "example-app-policy"

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,128}$", var.policy_name))
    error_message = "policy_name deve conter entre 1 e 128 caracteres validos para nomes de IAM Policy (letras, numeros e + = , . @ - _)."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy gerenciada via Terraform com acoes e recursos explicitos."
}

variable "trusted_principal_arn" {
  description = "ARN do principal (role, usuario ou conta especifica) autorizado a assumir esta role. Nao pode ser um wildcard."
  type        = string

  validation {
    condition = (
      var.trusted_principal_arn != "*" &&
      can(regex("^arn:aws:iam::\\d{12}:(root|user/[\\w+=,.@-]+|role/[\\w+=,.@/-]+)$", var.trusted_principal_arn))
    )
    error_message = "trusted_principal_arn deve ser um ARN IAM especifico (conta, usuario ou role) e nao pode ser \"*\"."
  }
}

variable "external_id" {
  description = "External ID opcional exigido na trust policy para mitigar o problema do 'confused deputy' em cenarios cross-account. Deixe null para nao exigir."
  type        = string
  default     = null
}

variable "max_session_duration" {
  description = "Duracao maxima (em segundos) da sessao assumida via esta role."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "allowed_actions" {
  description = "Lista explicita de acoes IAM permitidas pela policy. Wildcard total (\"*\") nao e permitido."
  type        = list(string)
  default = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  validation {
    condition     = length(var.allowed_actions) > 0 && !contains(var.allowed_actions, "*")
    error_message = "allowed_actions nao pode ser vazio nem conter o wildcard total \"*\"."
  }
}

variable "allowed_resources" {
  description = "Lista explicita de ARNs de recursos aos quais as allowed_actions se aplicam. Wildcard total (\"*\") nao e permitido."
  type        = list(string)
  default = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*",
  ]

  validation {
    condition     = length(var.allowed_resources) > 0 && !contains(var.allowed_resources, "*")
    error_message = "allowed_resources nao pode ser vazio nem conter o wildcard total \"*\"."
  }
}

variable "tags" {
  description = "Tags aplicadas a role e a policy."
  type        = map(string)
  default     = {}
}
