variable "region" {
  description = "Regiao AWS utilizada pelo provider."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string
  default     = "example-app-role"
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada e anexada a role."
  type        = string
  default     = "example-app-policy"
}

variable "path" {
  description = "Path aplicado tanto a role quanto a policy."
  type        = string
  default     = "/"
}

variable "max_session_duration" {
  description = "Duracao maxima (em segundos) da sessao assumida via a role."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "permissions_boundary_arn" {
  description = "ARN opcional de uma permissions boundary a ser aplicada a role. Use null para nao aplicar nenhuma."
  type        = string
  default     = null

  validation {
    condition     = var.permissions_boundary_arn == null || can(regex("^arn:aws:iam::\\d{12}:policy/.+$", var.permissions_boundary_arn))
    error_message = "permissions_boundary_arn deve ser null ou um ARN valido de policy IAM (arn:aws:iam::<account-id>:policy/<nome>)."
  }
}

variable "trusted_principal_arns" {
  description = "Lista de ARNs de principals (contas, roles ou usuarios) autorizados a assumir a role. Nao pode conter wildcard."
  type        = list(string)
  default     = ["arn:aws:iam::123456789012:root"]

  validation {
    condition     = length(var.trusted_principal_arns) > 0
    error_message = "trusted_principal_arns deve conter pelo menos um principal."
  }

  validation {
    condition     = !contains(var.trusted_principal_arns, "*")
    error_message = "trusted_principal_arns nao pode conter o wildcard \"*\" (qualquer principal)."
  }

  validation {
    condition     = alltrue([for arn in var.trusted_principal_arns : can(regex("^arn:aws:iam::\\d{12}:(root|user/.+|role/.+)$", arn))])
    error_message = "Cada item de trusted_principal_arns deve ser um ARN IAM valido (root, user ou role) com conta especifica."
  }
}

variable "external_id" {
  description = "External ID opcional exigido na trust policy (sts:ExternalId). Deixe em branco para nao exigir."
  type        = string
  default     = ""
}

variable "allowed_actions" {
  description = "Lista de actions IAM permitidas pela policy. Nao pode conter o wildcard total \"*\"."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter pelo menos uma action."
  }

  validation {
    condition     = !contains(var.allowed_actions, "*")
    error_message = "allowed_actions nao pode conter o wildcard total \"*\"."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos sobre os quais allowed_actions e permitido."
  type        = list(string)
  default     = ["arn:aws:s3:::example-bucket-placeholder", "arn:aws:s3:::example-bucket-placeholder/*"]

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter pelo menos um recurso."
  }
}

variable "tags" {
  description = "Tags aplicadas a role e a policy."
  type        = map(string)
  default     = {}
}
