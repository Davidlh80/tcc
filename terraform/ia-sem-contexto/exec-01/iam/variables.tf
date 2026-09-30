variable "aws_region" {
  description = "Regiao AWS onde os recursos IAM serao provisionados (IAM e global, mas o provider exige uma regiao)."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role."
  type        = string
  default     = "example-role"
}

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "IAM role managed by Terraform blueprint"
}

variable "policy_name" {
  description = "Nome da IAM Policy gerenciada anexada a role."
  type        = string
  default     = "example-policy"
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Least-privilege permissions policy attached to the IAM role"
}

variable "path" {
  description = "Path aplicado tanto a role quanto a policy."
  type        = string
  default     = "/"
}

variable "max_session_duration" {
  description = "Duracao maxima (em segundos) de uma sessao assumida via esta role."
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
  description = "ARN opcional de uma policy usada como permissions boundary da role."
  type        = string
  default     = null

  validation {
    condition     = var.permissions_boundary_arn == null || can(regex("^arn:aws:iam::[0-9]{12}:policy/.+$", var.permissions_boundary_arn))
    error_message = "permissions_boundary_arn deve ser nulo ou um ARN valido no formato arn:aws:iam::<account-id>:policy/<nome>."
  }
}

variable "trusted_principal_type" {
  description = "Tipo do principal de confianca da assume role policy (Service, AWS ou Federated)."
  type        = string
  default     = "Service"

  validation {
    condition     = contains(["Service", "AWS", "Federated"], var.trusted_principal_type)
    error_message = "trusted_principal_type deve ser um dos valores: Service, AWS, Federated."
  }
}

variable "trusted_principal_identifiers" {
  description = "Lista de identificadores do principal de confianca (ex.: [\"lambda.amazonaws.com\"] ou [\"arn:aws:iam::111122223333:root\"])."
  type        = list(string)
  default     = ["lambda.amazonaws.com"]

  validation {
    condition     = length(var.trusted_principal_identifiers) > 0
    error_message = "trusted_principal_identifiers nao pode ser uma lista vazia."
  }
}

variable "external_id" {
  description = "External ID opcional exigido na assume role policy (recomendado para principals AWS de terceiros)."
  type        = string
  default     = null
}

variable "allowed_actions" {
  description = "Lista explicita de acoes IAM permitidas pela policy. Wildcards totais (\"*\") nao sao aceitos."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma acao."
  }

  validation {
    condition     = alltrue([for action in var.allowed_actions : action != "*"])
    error_message = "allowed_actions nao pode conter o wildcard total \"*\"; utilize acoes explicitas ou wildcards de servico (ex.: \"s3:Get*\")."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos aos quais as allowed_actions se aplicam."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }
}

variable "tags" {
  description = "Tags aplicadas a role e a policy."
  type        = map(string)
  default     = {}
}
