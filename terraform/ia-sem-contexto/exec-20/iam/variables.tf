variable "aws_region" {
  description = "Regiao AWS onde o provider ira operar."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string
  default     = "app-scoped-role"

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
  default     = "Role com permissoes minimas necessarias, criada via Terraform."
}

variable "max_session_duration" {
  description = "Duracao maxima (em segundos) da sessao assumida via sts:AssumeRole."
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

variable "trusted_principal_type" {
  description = "Tipo do principal de confianca no trust policy (AWS, Service ou Federated)."
  type        = string
  default     = "Service"

  validation {
    condition     = contains(["AWS", "Service", "Federated"], var.trusted_principal_type)
    error_message = "trusted_principal_type deve ser \"AWS\", \"Service\" ou \"Federated\"."
  }
}

variable "trusted_principal_identifiers" {
  description = "Lista de identificadores do principal de confianca (ex.: ARNs de conta/usuario/role ou nomes de servico como ec2.amazonaws.com)."
  type        = list(string)
  default     = ["ec2.amazonaws.com"]

  validation {
    condition     = length(var.trusted_principal_identifiers) > 0
    error_message = "trusted_principal_identifiers nao pode ser uma lista vazia."
  }
}

variable "external_id" {
  description = "External ID opcional exigido na condicao sts:ExternalId do trust policy (recomendado quando o principal for de outra conta/terceiro)."
  type        = string
  default     = null
}

variable "require_mfa" {
  description = "Se true, exige aws:MultiFactorAuthPresent=true para assumir a role."
  type        = bool
  default     = false
}

variable "policy_name" {
  description = "Nome da IAM Policy gerenciada anexada a role."
  type        = string
  default     = "app-scoped-policy"

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
  default     = "Policy com acoes e recursos explicitamente definidos, sem uso de wildcard amplo."
}

variable "allowed_actions" {
  description = "Lista de acoes IAM explicitamente permitidas pela policy. Nao aceita o valor \"*\"."
  type        = list(string)
  default = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  validation {
    condition     = length(var.allowed_actions) > 0 && !contains(var.allowed_actions, "*")
    error_message = "allowed_actions nao pode ser vazio nem conter o wildcard \"*\"."
  }
}

variable "resource_arns" {
  description = "Lista de ARNs de recursos aos quais allowed_actions se aplica. Nao aceita o valor \"*\"."
  type        = list(string)
  default = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*",
  ]

  validation {
    condition     = length(var.resource_arns) > 0 && !contains(var.resource_arns, "*")
    error_message = "resource_arns nao pode ser vazio nem conter o wildcard \"*\"."
  }
}

variable "tags" {
  description = "Tags aplicadas a role e a policy."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
  }
}
