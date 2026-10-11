variable "aws_region" {
  type        = string
  description = "Região AWS onde os recursos IAM serão avaliados/validados pelo provider."
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

variable "role_path" {
  type        = string
  description = "Path da IAM Role."
  default     = "/"
}

variable "role_description" {
  type        = string
  description = "Descrição da IAM Role."
  default     = "Role gerenciada via Terraform com permissões restritas."
}

variable "max_session_duration" {
  type        = number
  description = "Duração máxima (em segundos) da sessão assumida via sts:AssumeRole."
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "permissions_boundary_arn" {
  type        = string
  description = "ARN de uma permissions boundary opcional a ser aplicada à role. Use null para não aplicar."
  default     = null
}

variable "trusted_principal_arns" {
  type        = list(string)
  description = "Lista de ARNs de principais (contas, roles ou usuários IAM) autorizados a assumir a role. Não é permitido usar \"*\"."

  validation {
    condition     = length(var.trusted_principal_arns) > 0
    error_message = "trusted_principal_arns não pode estar vazio: é necessário informar ao menos um principal confiável."
  }

  validation {
    condition     = !contains(var.trusted_principal_arns, "*")
    error_message = "trusted_principal_arns não pode conter \"*\": a trust policy não pode permitir qualquer principal."
  }
}

variable "external_id" {
  type        = string
  description = "External ID opcional exigido na condição sts:ExternalId da trust policy. Use null para não exigir."
  default     = null
}

variable "policy_name" {
  type        = string
  description = "Nome da IAM Policy a ser criada e anexada à role."

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128
    error_message = "policy_name deve ter entre 1 e 128 caracteres."
  }
}

variable "policy_path" {
  type        = string
  description = "Path da IAM Policy."
  default     = "/"
}

variable "policy_description" {
  type        = string
  description = "Descrição da IAM Policy."
  default     = "Policy gerenciada via Terraform com permissões restritas, anexada a uma role específica."
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de ações IAM permitidas pela policy. Evite ações administrativas amplas (ex.: \"*\", \"iam:*\")."
  default = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions não pode estar vazio."
  }

  validation {
    condition     = !contains(var.allowed_actions, "*")
    error_message = "allowed_actions não pode conter a ação wildcard \"*\": restrinja às ações necessárias."
  }

  validation {
    condition     = !contains(var.allowed_actions, "iam:*")
    error_message = "allowed_actions não pode conter \"iam:*\": evite conceder permissões administrativas de IAM."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos aos quais as ações permitidas se aplicam. Prefira ARNs específicos em vez de \"*\"."
  default = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*",
  ]

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources não pode estar vazio."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas à role e à policy."
  default     = {}
}
