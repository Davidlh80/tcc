variable "aws_region" {
  type        = string
  description = "Regiao AWS utilizada pelo provider."
  default     = "us-east-1"
}

variable "role_name" {
  type        = string
  description = "Nome da IAM Role."
  default     = "app-role"

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,64}$", var.role_name))
    error_message = "role_name deve ter entre 1 e 64 caracteres validos para nomes de IAM Role (letras, numeros e + = , . @ -)."
  }
}

variable "policy_name" {
  type        = string
  description = "Nome da IAM Policy."
  default     = "app-policy"

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,128}$", var.policy_name))
    error_message = "policy_name deve ter entre 1 e 128 caracteres validos para nomes de IAM Policy (letras, numeros e + = , . @ -)."
  }
}

variable "path" {
  type        = string
  description = "Path aplicado a role e a policy."
  default     = "/"
}

variable "description" {
  type        = string
  description = "Descricao da IAM Role."
  default     = "Role gerenciada via Terraform com permissoes minimas necessarias."
}

variable "assume_role_principal_type" {
  type        = string
  description = "Tipo de principal de confianca da assume role policy (Service ou AWS)."
  default     = "Service"

  validation {
    condition     = contains(["Service", "AWS"], var.assume_role_principal_type)
    error_message = "assume_role_principal_type deve ser \"Service\" ou \"AWS\"."
  }
}

variable "assume_role_principal_identifiers" {
  type        = list(string)
  description = "Identificadores do principal de confianca (ex.: servico AWS como ec2.amazonaws.com, ou ARNs de conta/role para tipo AWS)."
  default     = ["ec2.amazonaws.com"]

  validation {
    condition     = length(var.assume_role_principal_identifiers) > 0
    error_message = "assume_role_principal_identifiers nao pode ser uma lista vazia."
  }
}

variable "assume_role_external_id" {
  type        = string
  description = "External ID opcional exigido na assume role policy (recomendado para principals do tipo AWS/cross-account)."
  default     = null
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de actions IAM permitidas na policy. Wildcard total (\"*\") nao e permitido."
  default = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  validation {
    condition     = length(var.allowed_actions) > 0 && !contains(var.allowed_actions, "*")
    error_message = "allowed_actions nao pode ser vazio nem conter o wildcard total \"*\"."
  }
}

variable "resource_arns" {
  type        = list(string)
  description = "Lista de ARNs de recursos aos quais as actions se aplicam. Wildcard total (\"*\") nao e permitido."
  default = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*",
  ]

  validation {
    condition     = length(var.resource_arns) > 0 && !contains(var.resource_arns, "*")
    error_message = "resource_arns nao pode ser vazio nem conter o wildcard total \"*\"."
  }
}

variable "max_session_duration" {
  type        = number
  description = "Duracao maxima (em segundos) da sessao assumida pela role."
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "force_detach_policies" {
  type        = bool
  description = "Se true, forca o desanexamento de policies ao destruir a role."
  default     = true
}

variable "permissions_boundary_arn" {
  type        = string
  description = "ARN opcional de uma permissions boundary a ser aplicada na role."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas a role e a policy."
  default = {
    ManagedBy = "terraform"
  }
}
