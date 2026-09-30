variable "aws_region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role."
  type        = string
  default     = "app-service-role"
}

variable "role_path" {
  description = "Path aplicado a IAM Role e a IAM Policy."
  type        = string
  default     = "/"
}

variable "policy_name" {
  description = "Nome da IAM Policy gerenciada."
  type        = string
  default     = "app-service-policy"
}

variable "assume_role_service_principals" {
  description = "Service principals da AWS autorizados a assumir a role (ex: ec2.amazonaws.com, lambda.amazonaws.com). Nao pode ficar vazio junto com trusted_account_ids."
  type        = list(string)
  default     = ["ec2.amazonaws.com"]

  validation {
    condition     = !contains(var.assume_role_service_principals, "")
    error_message = "assume_role_service_principals nao pode conter strings vazias."
  }
}

variable "trusted_account_ids" {
  description = "IDs de contas AWS externas autorizadas a assumir a role via sts:AssumeRole (cross-account). Deixe vazio para desabilitar esse caminho de confianca."
  type        = list(string)
  default     = []
}

variable "external_id" {
  description = "Valor exigido na condicao sts:ExternalId quando trusted_account_ids esta preenchido. Recomendado sempre que houver confianca cross-account."
  type        = string
  default     = null
}

variable "max_session_duration" {
  description = "Duracao maxima, em segundos, de uma sessao assumida da role."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "force_detach_policies" {
  description = "Se true, forca o desanexo de policies gerenciadas ao destruir a role."
  type        = bool
  default     = true
}

variable "policy_actions" {
  description = "Lista de IAM actions permitidas pela policy. O wildcard total \"*\" nao e permitido."
  type        = list(string)
  default = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  validation {
    condition     = !contains(var.policy_actions, "*")
    error_message = "policy_actions nao pode conter o wildcard total \"*\"."
  }
}

variable "policy_resources" {
  description = "Lista de ARNs de recursos cobertos pela policy."
  type        = list(string)
  default = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*",
  ]

  validation {
    condition     = length(var.policy_resources) > 0
    error_message = "policy_resources nao pode ser uma lista vazia."
  }
}

variable "tags" {
  description = "Tags aplicadas a IAM Role e a IAM Policy."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
  }
}
