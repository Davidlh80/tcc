variable "region" {
  type        = string
  description = "Regiao AWS utilizada pelo provider."
  default     = "us-east-1"
}

variable "role_name" {
  type        = string
  description = "Nome da IAM Role a ser criada."

  validation {
    condition     = length(var.role_name) > 0 && length(var.role_name) <= 64
    error_message = "role_name deve ter entre 1 e 64 caracteres."
  }
}

variable "role_description" {
  type        = string
  description = "Descricao da IAM Role."
  default     = "IAM Role gerenciada via Terraform."
}

variable "policy_name" {
  type        = string
  description = "Nome da IAM Policy a ser criada e anexada a role."

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128
    error_message = "policy_name deve ter entre 1 e 128 caracteres."
  }
}

variable "policy_description" {
  type        = string
  description = "Descricao da IAM Policy."
  default     = "IAM Policy gerenciada via Terraform."
}

variable "path" {
  type        = string
  description = "Path aplicado a role e a policy."
  default     = "/"
}

variable "trusted_service_principals" {
  type        = list(string)
  description = "Servicos AWS autorizados a assumir a role (ex: ec2.amazonaws.com, lambda.amazonaws.com)."
  default     = []
}

variable "trusted_account_principals" {
  type        = list(string)
  description = "ARNs de contas ou entidades IAM autorizadas a assumir a role via sts:AssumeRole."
  default     = []
}

variable "external_id" {
  type        = string
  description = "External ID exigido no assume role para principals de conta (recomendado em acessos cross-account de terceiros)."
  default     = null
  sensitive   = true
}

variable "max_session_duration" {
  type        = number
  description = "Duracao maxima, em segundos, da sessao assumida da role (entre 3600 e 43200)."
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "permissions_boundary_arn" {
  type        = string
  description = "ARN da policy usada como permissions boundary da role. Deixe null para nao aplicar boundary."
  default     = null
}

variable "force_detach_policies" {
  type        = bool
  description = "Se true, forca o desanexo de policies ao destruir a role."
  default     = true
}

variable "policy_effect" {
  type        = string
  description = "Efeito da statement principal da policy (Allow ou Deny)."
  default     = "Allow"

  validation {
    condition     = contains(["Allow", "Deny"], var.policy_effect)
    error_message = "policy_effect deve ser \"Allow\" ou \"Deny\"."
  }
}

variable "policy_actions" {
  type        = list(string)
  description = "Lista de actions IAM permitidas/negadas pela policy. Evite \"*\" em producao."

  validation {
    condition     = length(var.policy_actions) > 0
    error_message = "policy_actions nao pode ser uma lista vazia."
  }
}

variable "policy_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos aos quais a policy se aplica. Evite \"*\" em producao."

  validation {
    condition     = length(var.policy_resources) > 0
    error_message = "policy_resources nao pode ser uma lista vazia."
  }
}

variable "allow_wildcard_actions" {
  type        = bool
  description = "Permite explicitamente o uso de \"*\" em policy_actions."
  default     = false
}

variable "allow_wildcard_resources" {
  type        = bool
  description = "Permite explicitamente o uso de \"*\" em policy_resources."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais aplicadas a role e a policy."
  default     = {}
}
