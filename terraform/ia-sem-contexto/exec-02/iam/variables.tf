variable "aws_region" {
  description = "Regiao AWS onde os recursos serao criados."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role."
  type        = string
  default     = "app-role"
}

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "IAM role gerenciada via Terraform"
}

variable "role_path" {
  description = "Path da IAM Role e da IAM Policy."
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
  description = "ARN de uma permissions boundary a ser aplicada na role (opcional)."
  type        = string
  default     = null
}

variable "trusted_service_principals" {
  description = "Lista de service principals autorizados a assumir a role (trust policy)."
  type        = list(string)
  default     = ["ec2.amazonaws.com"]

  validation {
    condition     = length(var.trusted_service_principals) > 0
    error_message = "Informe ao menos um service principal confiavel."
  }
}

variable "external_id" {
  description = "External ID exigido no AssumeRole, util para cenarios cross-account (opcional)."
  type        = string
  default     = null
}

variable "policy_name" {
  description = "Nome da IAM Policy anexada a role."
  type        = string
  default     = "app-role-policy"
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy de privilegio minimo anexada a IAM role"
}

variable "allowed_actions" {
  description = "Lista de actions permitidas na policy. Evite '*' salvo necessidade explicita."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "Informe ao menos uma action permitida."
  }

  validation {
    condition     = var.allow_wildcard_actions || !contains(var.allowed_actions, "*")
    error_message = "Action '*' nao e permitida a menos que allow_wildcard_actions seja true."
  }
}

variable "allow_wildcard_actions" {
  description = "Permite explicitamente o uso de action '*' em allowed_actions."
  type        = bool
  default     = false
}

variable "allowed_resource_arns" {
  description = "Lista de ARNs de recursos sobre os quais as actions sao permitidas. Evite '*' salvo necessidade explicita."
  type        = list(string)
  default     = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]

  validation {
    condition     = length(var.allowed_resource_arns) > 0
    error_message = "Informe ao menos um ARN de recurso."
  }

  validation {
    condition     = var.allow_wildcard_resources || !contains(var.allowed_resource_arns, "*")
    error_message = "Resource '*' nao e permitido a menos que allow_wildcard_resources seja true."
  }
}

variable "allow_wildcard_resources" {
  description = "Permite explicitamente o uso de resource '*' em allowed_resource_arns."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags aplicadas a role e a policy."
  type        = map(string)
  default     = {}
}
