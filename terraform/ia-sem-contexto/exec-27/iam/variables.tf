variable "aws_region" {
  description = "Regiao AWS utilizada pelo provider."
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Prefixo usado para nomear a role e a policy criadas."
  type        = string
  default     = "example"

  validation {
    condition     = length(var.name_prefix) > 0 && length(var.name_prefix) <= 32
    error_message = "name_prefix deve ter entre 1 e 32 caracteres."
  }
}

variable "trusted_principal_arn" {
  description = "ARN do principal (role, user ou conta) autorizado a assumir a role. Nao pode ser um wildcard."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws:iam::[0-9]{12}:(root|(user|role)\\/.+)$", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM valido (conta, role ou user) e nao pode ser \"*\"."
  }
}

variable "external_id" {
  description = "ExternalId opcional exigido na trust policy para mitigar o problema do confused deputy."
  type        = string
  default     = null
}

variable "max_session_duration" {
  description = "Duracao maxima, em segundos, de uma sessao assumida pela role."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "policy_actions" {
  description = "Lista de actions IAM permitidas pela policy. Nao deve conter wildcards amplos (ex: \"*\" ou \"iam:*\")."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.policy_actions) > 0 && !contains(var.policy_actions, "*") && !contains(var.policy_actions, "iam:*")
    error_message = "policy_actions nao pode ser vazio nem conter \"*\" ou \"iam:*\"."
  }
}

variable "policy_resources" {
  description = "Lista de ARNs de recursos aos quais as actions se aplicam. Nao deve conter \"*\"."
  type        = list(string)
  default     = ["arn:aws:s3:::example-bucket/*"]

  validation {
    condition     = length(var.policy_resources) > 0 && !contains(var.policy_resources, "*")
    error_message = "policy_resources nao pode ser vazio nem conter \"*\"."
  }
}

variable "tags" {
  description = "Tags aplicadas a role e a policy."
  type        = map(string)
  default     = {}
}
