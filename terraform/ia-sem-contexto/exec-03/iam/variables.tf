variable "aws_region" {
  description = "Região AWS usada pelo provider. Recursos IAM são globais, mas o provider exige uma região."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role."
  type        = string
  default     = "app-role"

  validation {
    condition     = length(var.role_name) > 0 && length(var.role_name) <= 64
    error_message = "role_name deve ter entre 1 e 64 caracteres."
  }
}

variable "role_description" {
  description = "Descrição da IAM Role."
  type        = string
  default     = "Role gerenciada via Terraform."
}

variable "policy_name" {
  description = "Nome da IAM Policy anexada à role."
  type        = string
  default     = "app-policy"

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128
    error_message = "policy_name deve ter entre 1 e 128 caracteres."
  }
}

variable "policy_description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "Policy gerenciada via Terraform."
}

variable "trusted_service_principals" {
  description = "Serviços AWS (ex: ec2.amazonaws.com) autorizados a assumir a role via sts:AssumeRole."
  type        = list(string)
  default     = ["ec2.amazonaws.com"]
}

variable "trusted_aws_principals" {
  description = "ARNs de contas, roles ou usuários AWS adicionais autorizados a assumir a role. Vazio por padrão (nenhum principal AWS além dos serviços)."
  type        = list(string)
  default     = []
}

variable "external_id" {
  description = "External ID exigido (condição sts:ExternalId) ao assumir a role a partir de trusted_aws_principals. Recomendado em cenários cross-account com terceiros. Deixe vazio para não exigir."
  type        = string
  default     = ""
  sensitive   = true
}

variable "max_session_duration" {
  description = "Duração máxima, em segundos, da sessão obtida via sts:AssumeRole."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "permissions_boundary_arn" {
  description = "ARN de uma IAM Policy a ser usada como permissions boundary da role. Deixe vazio para não aplicar boundary."
  type        = string
  default     = ""
}

variable "policy_statements" {
  description = "Statements da IAM Policy anexada à role. Defina ações e recursos com o menor privilégio necessário; wildcards (*) não são permitidos em actions ou resources."
  type = list(object({
    sid       = string
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))

  default = [
    {
      sid       = "AllowReadOnlyExampleBucket"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]
    }
  ]

  validation {
    condition     = length(var.policy_statements) > 0
    error_message = "policy_statements deve conter ao menos um statement."
  }

  validation {
    condition     = alltrue([for s in var.policy_statements : contains(["Allow", "Deny"], s.effect)])
    error_message = "O campo effect de cada statement deve ser \"Allow\" ou \"Deny\"."
  }

  validation {
    condition     = alltrue([for s in var.policy_statements : !contains(s.actions, "*")])
    error_message = "Wildcard \"*\" não é permitido em actions; especifique ações explícitas."
  }

  validation {
    condition     = alltrue([for s in var.policy_statements : !contains(s.resources, "*")])
    error_message = "Wildcard \"*\" não é permitido em resources; especifique ARNs explícitos."
  }
}

variable "tags" {
  description = "Tags aplicadas à IAM Role e à IAM Policy."
  type        = map(string)
  default     = {}
}
