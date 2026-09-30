variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string
  default     = "app-role"

  validation {
    condition     = length(var.role_name) > 0 && length(var.role_name) <= 64
    error_message = "role_name deve ter entre 1 e 64 caracteres."
  }
}

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "Role gerenciada via Terraform com politica de privilegio minimo anexada."
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada e anexada a role."
  type        = string
  default     = "app-policy"

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128
    error_message = "policy_name deve ter entre 1 e 128 caracteres."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Politica de privilegio minimo com acoes e recursos explicitos."
}

variable "path" {
  description = "Path aplicado tanto a role quanto a policy."
  type        = string
  default     = "/"
}

variable "trusted_principal_service" {
  description = "Principal de servico AWS autorizado a assumir a role (trust policy). Ex.: ec2.amazonaws.com, lambda.amazonaws.com."
  type        = string
  default     = "ec2.amazonaws.com"

  validation {
    condition     = can(regex("^[a-zA-Z0-9.-]+\\.amazonaws\\.com$", var.trusted_principal_service))
    error_message = "trusted_principal_service deve ser um principal de servico valido, ex.: ec2.amazonaws.com."
  }
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

variable "allowed_actions" {
  description = "Lista explicita de acoes IAM permitidas pela policy. Evite wildcards amplos como \"*\" ou \"service:*\"."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.allowed_actions) > 0 && alltrue([for a in var.allowed_actions : a != "*"])
    error_message = "allowed_actions nao pode ser vazio nem conter o wildcard total \"*\"."
  }
}

variable "allowed_resources" {
  description = "Lista explicita de ARNs de recursos aos quais as acoes se aplicam. Evite o wildcard \"*\"."
  type        = list(string)
  default     = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]

  validation {
    condition     = length(var.allowed_resources) > 0 && alltrue([for r in var.allowed_resources : r != "*"])
    error_message = "allowed_resources nao pode ser vazio nem conter o wildcard total \"*\"."
  }
}

variable "tags" {
  description = "Tags aplicadas a role e a policy."
  type        = map(string)
  default     = {}
}
