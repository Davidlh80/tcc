variable "aws_region" {
  description = "Região AWS onde os recursos IAM serão provisionados (IAM é global, mas o provider exige uma região)."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string
  default     = "example-restricted-role"

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
  description = "Descrição da IAM Role."
  type        = string
  default     = "Role criada via Terraform com trust policy restrita e policy dedicada anexada."
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

variable "permissions_boundary_arn" {
  description = "ARN opcional de uma policy a ser usada como permissions boundary da role."
  type        = string
  default     = null
}

variable "trusted_principal_arns" {
  description = "Lista de ARNs de principals (IAM role ou user) autorizados a assumir a role. Não é permitido usar '*' ou principals de conta inteira (root)."
  type        = list(string)
  default     = ["arn:aws:iam::123456789012:role/example-trusted-role"]

  validation {
    condition     = length(var.trusted_principal_arns) > 0
    error_message = "trusted_principal_arns deve conter ao menos um ARN."
  }

  validation {
    condition = alltrue([
      for arn in var.trusted_principal_arns :
      arn != "*" && can(regex("^arn:aws:iam::[0-9]{12}:(role|user)/.+$", arn))
    ])
    error_message = "Cada item de trusted_principal_arns deve ser um ARN específico de IAM role ou user (formato arn:aws:iam::<account-id>:role/... ou :user/...). Não é permitido '*' ou ARN de conta inteira (root)."
  }
}

variable "external_id" {
  description = "External ID opcional exigido na assume role policy, para reforçar o controle de quem pode assumir a role (ex.: cenários cross-account)."
  type        = string
  default     = ""
  sensitive   = true
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada e anexada à role."
  type        = string
  default     = "example-restricted-policy"

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
  description = "Descrição da IAM Policy."
  type        = string
  default     = "Policy com permissões específicas, anexada exclusivamente à role criada por este módulo."
}

variable "policy_actions" {
  description = "Lista de actions IAM permitidas pela policy. Não é permitido usar o wildcard total '*'."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.policy_actions) > 0 && !contains(var.policy_actions, "*")
    error_message = "policy_actions deve conter ao menos uma action e não pode incluir o wildcard total '*'."
  }
}

variable "policy_resources" {
  description = "Lista de ARNs de recursos aos quais as actions se aplicam. Não é permitido usar o wildcard total '*' (todos os recursos)."
  type        = list(string)
  default     = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]

  validation {
    condition     = length(var.policy_resources) > 0 && !contains(var.policy_resources, "*")
    error_message = "policy_resources deve conter ao menos um ARN e não pode ser '*' (todos os recursos)."
  }
}

variable "tags" {
  description = "Mapa de tags aplicadas à IAM Role e à IAM Policy."
  type        = map(string)
  default     = {}
}
