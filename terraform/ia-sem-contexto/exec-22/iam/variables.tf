variable "region" {
  description = "Regiao AWS usada apenas para configuracao do provider (nao requer credenciais para terraform validate)."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string
  default     = "example-app-role"

  validation {
    condition     = length(var.role_name) > 0 && length(var.role_name) <= 64
    error_message = "role_name deve ter entre 1 e 64 caracteres."
  }
}

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "Role gerenciada via Terraform com permissoes restritas as acoes configuradas."
}

variable "policy_name" {
  description = "Nome da IAM Policy gerenciada, anexada a role."
  type        = string
  default     = "example-app-policy"

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128
    error_message = "policy_name deve ter entre 1 e 128 caracteres."
  }
}

variable "path" {
  description = "Path da IAM Role e da IAM Policy."
  type        = string
  default     = "/"
}

variable "trusted_principal_type" {
  description = "Tipo do principal de confianca no assume role policy (AWS, Service ou Federated)."
  type        = string
  default     = "Service"

  validation {
    condition     = contains(["AWS", "Service", "Federated"], var.trusted_principal_type)
    error_message = "trusted_principal_type deve ser AWS, Service ou Federated."
  }
}

variable "trusted_principal_identifiers" {
  description = "Identificadores do principal de confianca (ex: [\"ec2.amazonaws.com\"] para Service, ou ARNs de conta/role para AWS)."
  type        = list(string)
  default     = ["ec2.amazonaws.com"]

  validation {
    condition     = length(var.trusted_principal_identifiers) > 0
    error_message = "trusted_principal_identifiers nao pode ser uma lista vazia."
  }
}

variable "external_id" {
  description = "External ID opcional exigido no assume role, recomendado para principals do tipo AWS (cross-account). Deixe vazio para nao exigir."
  type        = string
  default     = ""
  sensitive   = true
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas na policy anexada a role. Evite wildcards amplos como \"*\"."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions nao pode ser uma lista vazia."
  }

  validation {
    condition     = !contains(var.allowed_actions, "*")
    error_message = "allowed_actions nao deve conter o wildcard \"*\" isolado; especifique acoes concretas."
  }
}

variable "resource_arns" {
  description = "Lista de ARNs de recursos aos quais as acoes permitidas se aplicam. Evite \"*\" em ambientes de producao."
  type        = list(string)
  default     = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]

  validation {
    condition     = length(var.resource_arns) > 0
    error_message = "resource_arns nao pode ser uma lista vazia."
  }
}

variable "max_session_duration" {
  description = "Duracao maxima (em segundos) da sessao assumida via a role, entre 3600 e 43200."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "permissions_boundary_arn" {
  description = "ARN opcional de uma policy de permissions boundary a ser aplicada a role. Deixe null para nao usar."
  type        = string
  default     = null
}

variable "force_detach_policies" {
  description = "Se true, permite que policies gerenciadas sejam desanexadas automaticamente ao destruir a role."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags aplicadas a role e a policy."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
  }
}
