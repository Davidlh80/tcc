variable "aws_region" {
  description = "Regiao AWS utilizada pelo provider."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role."
  type        = string
  default     = "app-service-role"

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]{1,64}$", var.role_name))
    error_message = "role_name deve ter entre 1 e 64 caracteres validos para nomes de IAM (letras, numeros e + = , . @ _ -)."
  }
}

variable "policy_name" {
  description = "Nome da IAM Policy anexada a role."
  type        = string
  default     = "app-service-policy"

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]{1,64}$", var.policy_name))
    error_message = "policy_name deve ter entre 1 e 64 caracteres validos para nomes de IAM (letras, numeros e + = , . @ _ -)."
  }
}

variable "path" {
  description = "Path IAM aplicado a role e a policy. Deve iniciar e terminar com '/'."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/([A-Za-z0-9+=,.@_-]+/)*$", var.path))
    error_message = "path deve iniciar e terminar com '/', por exemplo '/' ou '/service-role/'."
  }
}

variable "assume_role_service_principals" {
  description = "Lista de service principals (ex: ec2.amazonaws.com) autorizados a assumir a role via sts:AssumeRole."
  type        = list(string)
  default     = ["ec2.amazonaws.com"]
}

variable "assume_role_account_principals" {
  description = "Lista de ARNs de contas/roles/usuarios AWS autorizados a assumir a role via sts:AssumeRole. Vazio por padrao (sem confianca cross-account)."
  type        = list(string)
  default     = []
}

variable "external_id" {
  description = "External ID exigido na condicao sts:ExternalId quando assume_role_account_principals for utilizado (recomendado para acesso cross-account de terceiros)."
  type        = string
  default     = null
}

variable "max_session_duration" {
  description = "Duracao maxima (em segundos) da sessao assumida da role."
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

  validation {
    condition     = var.permissions_boundary_arn == null ? true : can(regex("^arn:aws:iam::[0-9]{12}:policy/.+$", var.permissions_boundary_arn))
    error_message = "permissions_boundary_arn deve ser nulo ou um ARN valido de IAM policy (arn:aws:iam::<account-id>:policy/<nome>)."
  }
}

variable "policy_statements" {
  description = "Lista de statements da IAM Policy. Nao permite actions ou resources coringa ('*') para forcar principio de menor privilegio."
  type = list(object({
    sid       = optional(string)
    effect    = optional(string, "Allow")
    actions   = list(string)
    resources = list(string)
  }))

  default = [
    {
      sid       = "AllowS3ReadOnlyExampleBucket"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = [
        "arn:aws:s3:::example-bucket",
        "arn:aws:s3:::example-bucket/*"
      ]
    }
  ]

  validation {
    condition     = alltrue([for s in var.policy_statements : !contains(s.actions, "*")])
    error_message = "Nenhum statement pode conter a action coringa '*'. Liste as actions explicitamente."
  }

  validation {
    condition     = alltrue([for s in var.policy_statements : !contains(s.resources, "*")])
    error_message = "Nenhum statement pode conter o resource coringa '*'. Liste os ARNs explicitamente."
  }

  validation {
    condition     = alltrue([for s in var.policy_statements : contains(["Allow", "Deny"], s.effect)])
    error_message = "O campo effect de cada statement deve ser 'Allow' ou 'Deny'."
  }
}

variable "tags" {
  description = "Tags aplicadas a role e a policy."
  type        = map(string)
  default     = {}
}
