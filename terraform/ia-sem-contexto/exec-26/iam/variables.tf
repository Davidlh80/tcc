variable "aws_region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role."
  type        = string
  default     = "app-restricted-role"
}

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "Role com trust policy restrita e permissoes de menor privilegio."
}

variable "policy_name" {
  description = "Nome da IAM Policy anexada a role."
  type        = string
  default     = "app-restricted-policy"
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy de menor privilegio anexada a uma IAM Role especifica."
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

variable "assume_role_principal_type" {
  description = "Tipo do principal autorizado a assumir a role (\"AWS\" ou \"Service\")."
  type        = string
  default     = "AWS"

  validation {
    condition     = contains(["AWS", "Service"], var.assume_role_principal_type)
    error_message = "assume_role_principal_type deve ser \"AWS\" ou \"Service\"."
  }
}

variable "assume_role_principal_identifiers" {
  description = "Lista de principais (ARNs de conta/role/usuario ou nomes de servico AWS) autorizados a assumir a role. Nao deve conter wildcard \"*\"."
  type        = list(string)
  default     = ["arn:aws:iam::123456789012:root"]

  validation {
    condition     = length(var.assume_role_principal_identifiers) > 0
    error_message = "assume_role_principal_identifiers nao pode ser uma lista vazia."
  }

  validation {
    condition     = !contains(var.assume_role_principal_identifiers, "*")
    error_message = "assume_role_principal_identifiers nao pode conter o wildcard \"*\"."
  }
}

variable "external_id" {
  description = "ExternalId opcional exigido na trust policy para mitigar o problema do confused deputy. Use null para nao exigir ExternalId."
  type        = string
  default     = null
}

variable "policy_actions" {
  description = "Lista de acoes IAM permitidas pela policy. Evite wildcard amplo (ex.: \"*\")."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = !contains(var.policy_actions, "*")
    error_message = "policy_actions nao pode conter o wildcard \"*\" (permissao administrativa ampla)."
  }
}

variable "policy_resources" {
  description = "Lista de ARNs de recursos aos quais as acoes da policy se aplicam. Evite wildcard amplo (ex.: \"*\")."
  type        = list(string)
  default     = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]

  validation {
    condition     = !contains(var.policy_resources, "*")
    error_message = "policy_resources nao pode conter o wildcard \"*\" (acesso irrestrito a recursos)."
  }
}

variable "tags" {
  description = "Tags aplicadas aos recursos IAM suportados."
  type        = map(string)
  default     = {}
}
