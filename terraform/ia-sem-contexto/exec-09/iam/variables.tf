variable "aws_region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role."
  type        = string
  default     = "app-restricted-role"

  validation {
    condition     = length(var.role_name) > 0 && length(var.role_name) <= 64
    error_message = "role_name deve ter entre 1 e 64 caracteres."
  }
}

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "IAM Role com permissoes restritas gerenciada via Terraform."
}

variable "role_path" {
  description = "Path utilizado pela IAM Role e pela IAM Policy."
  type        = string
  default     = "/"
}

variable "max_session_duration" {
  description = "Duracao maxima, em segundos, de uma sessao obtida via sts:AssumeRole."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "permissions_boundary_arn" {
  description = "ARN opcional de uma permissions boundary aplicada a IAM Role."
  type        = string
  default     = null
}

variable "trusted_principal_arns" {
  description = "Lista de ARNs de principals (contas, roles ou usuarios IAM) autorizados a assumir a role. Nao pode conter '*'."
  type        = list(string)

  validation {
    condition     = length(var.trusted_principal_arns) > 0
    error_message = "trusted_principal_arns deve conter ao menos um ARN."
  }

  validation {
    condition     = alltrue([for p in var.trusted_principal_arns : p != "*"])
    error_message = "trusted_principal_arns nao pode conter o principal '*' (qualquer conta ou principal)."
  }

  validation {
    condition = alltrue([
      for p in var.trusted_principal_arns :
      startswith(p, "arn:aws:iam::") || startswith(p, "arn:aws-us-gov:iam::") || startswith(p, "arn:aws-cn:iam::")
    ])
    error_message = "Cada item de trusted_principal_arns deve ser um ARN IAM valido (ex: arn:aws:iam::123456789012:role/nome)."
  }
}

variable "external_id" {
  description = "ExternalId opcional exigido via condicao sts:ExternalId na trust policy, para mitigar o problema do confused deputy."
  type        = string
  default     = null
}

variable "policy_name" {
  description = "Nome da IAM Policy anexada a role."
  type        = string
  default     = "app-restricted-policy"

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128
    error_message = "policy_name deve ter entre 1 e 128 caracteres."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "IAM Policy com permissoes restritas gerenciada via Terraform."
}

variable "allowed_actions" {
  description = "Lista de actions IAM permitidas pela policy. Evite wildcards amplos (ex: '*', 'iam:*', 'servico:*')."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma action."
  }

  validation {
    condition     = alltrue([for a in var.allowed_actions : a != "*" && !endswith(a, ":*")])
    error_message = "allowed_actions nao pode conter '*' nem wildcards amplos no formato 'servico:*'."
  }

  validation {
    condition = alltrue([
      for a in var.allowed_actions :
      lower(a) != "iam:*" &&
      !startswith(lower(a), "iam:create") &&
      !startswith(lower(a), "iam:attach") &&
      !startswith(lower(a), "iam:put") &&
      !startswith(lower(a), "iam:delete") &&
      !startswith(lower(a), "iam:update")
    ])
    error_message = "allowed_actions nao deve incluir actions administrativas de IAM (ex: iam:Create*, iam:Attach*, iam:Put*, iam:Delete*, iam:Update*)."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs/recursos sobre os quais as allowed_actions sao permitidas. Evite o wildcard '*'."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }

  validation {
    condition     = alltrue([for r in var.allowed_resources : r != "*"])
    error_message = "allowed_resources nao deve conter o wildcard amplo '*'. Especifique ARNs ou prefixos de recursos."
  }
}

variable "tags" {
  description = "Tags aplicadas a IAM Role e a IAM Policy."
  type        = map(string)
  default     = {}
}
