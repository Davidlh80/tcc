variable "aws_region" {
  description = "Regiao AWS onde os recursos serao provisionados (usada apenas para configuracao do provider)."
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

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "IAM Role de uso especifico com permissoes minimas necessarias."
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada e anexada a role."
  type        = string
  default     = "app-scoped-policy"

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128
    error_message = "policy_name deve ter entre 1 e 128 caracteres."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy com permissoes minimas necessarias, anexada a uma IAM Role especifica."
}

variable "trusted_principal_type" {
  description = "Tipo do principal de confianca no assume role policy (Service ou AWS)."
  type        = string
  default     = "Service"

  validation {
    condition     = contains(["Service", "AWS"], var.trusted_principal_type)
    error_message = "trusted_principal_type deve ser \"Service\" ou \"AWS\"."
  }
}

variable "trusted_principal_identifiers" {
  description = "Lista de identificadores do principal de confianca (ex.: [\"ec2.amazonaws.com\"] ou [\"arn:aws:iam::123456789012:root\"]). Nao use \"*\"."
  type        = list(string)
  default     = ["ec2.amazonaws.com"]

  validation {
    condition     = length(var.trusted_principal_identifiers) > 0 && !contains(var.trusted_principal_identifiers, "*")
    error_message = "trusted_principal_identifiers nao pode ser vazio nem conter o wildcard \"*\"."
  }
}

variable "external_id" {
  description = "External ID exigido no assume role, recomendado para cenarios cross-account. Deixe null para nao exigir."
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

variable "permissions_boundary_arn" {
  description = "ARN de uma permissions boundary a ser aplicada na role. Deixe null para nao aplicar."
  type        = string
  default     = null
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas na policy. Nao use o wildcard \"*\"."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.allowed_actions) > 0 && !contains(var.allowed_actions, "*")
    error_message = "allowed_actions nao pode ser vazio nem conter o wildcard \"*\"."
  }
}

variable "resource_arns" {
  description = "Lista de ARNs de recursos aos quais as acoes permitidas se aplicam. Nao use o wildcard \"*\"; defina ARNs especificos."
  type        = list(string)

  validation {
    condition     = length(var.resource_arns) > 0 && !contains(var.resource_arns, "*")
    error_message = "resource_arns nao pode ser vazio nem conter o wildcard \"*\"."
  }
}

variable "tags" {
  description = "Tags a serem aplicadas na IAM Role e na IAM Policy."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
  }
}
