variable "aws_region" {
  description = "Região AWS onde os recursos IAM serão avaliados/criados."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role."
  type        = string
  default     = "example-scoped-role"

  validation {
    condition     = length(var.role_name) > 0 && length(var.role_name) <= 64
    error_message = "role_name deve ter entre 1 e 64 caracteres."
  }
}

variable "role_description" {
  description = "Descrição da IAM Role."
  type        = string
  default     = "Role criada via blueprint Terraform com policy escopada."
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

variable "trusted_principal_arn" {
  description = "ARN do principal (conta, role ou usuário) autorizado a assumir a role. Não pode ser wildcard."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws:iam::\\d{12}:(root|user/.+|role/.+)$", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM válido (conta root, user ou role) e não pode ser \"*\"."
  }
}

variable "policy_name" {
  description = "Nome da IAM Policy."
  type        = string
  default     = "example-scoped-policy"

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128
    error_message = "policy_name deve ter entre 1 e 128 caracteres."
  }
}

variable "policy_description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "Policy com permissões escopadas, sem wildcard amplo nem privilégios administrativos."
}

variable "policy_actions" {
  description = "Lista de ações IAM permitidas pela policy. Evite ações administrativas amplas (ex: \"*\")."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.policy_actions) > 0 && !contains(var.policy_actions, "*")
    error_message = "policy_actions não pode estar vazia nem conter a ação wildcard \"*\"."
  }
}

variable "policy_resources" {
  description = "Lista de ARNs de recursos aos quais as ações se aplicam. Não pode conter wildcard global \"*\"."
  type        = list(string)
  default     = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]

  validation {
    condition     = length(var.policy_resources) > 0 && alltrue([for r in var.policy_resources : r != "*"])
    error_message = "policy_resources não pode estar vazia nem conter o wildcard global \"*\"."
  }
}

variable "tags" {
  description = "Tags aplicadas à IAM Role e à IAM Policy."
  type        = map(string)
  default     = {}
}
