variable "aws_region" {
  description = "Regiao AWS onde os recursos serao criados."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role."
  type        = string
  default     = "app-execution-role"

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_-]{1,64}$", var.role_name))
    error_message = "role_name deve conter apenas caracteres validos para nomes de IAM (letras, numeros e + = , . @ _ -) e ate 64 caracteres."
  }
}

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "Role de execucao com permissoes minimas necessarias para a aplicacao."
}

variable "policy_name" {
  description = "Nome da IAM Policy gerenciada."
  type        = string
  default     = "app-least-privilege-policy"

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_-]{1,128}$", var.policy_name))
    error_message = "policy_name deve conter apenas caracteres validos para nomes de IAM (letras, numeros e + = , . @ _ -) e ate 128 caracteres."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy com permissoes especificas, sem wildcards, anexada a uma unica role."
}

variable "path" {
  description = "Path aplicado a role e a policy."
  type        = string
  default     = "/"
}

variable "trusted_service_principals" {
  description = "Lista de service principals AWS autorizados a assumir a role (trust policy). Nao inclua contas/roles externas sem avaliacao de seguranca."
  type        = list(string)
  default     = ["ec2.amazonaws.com"]

  validation {
    condition     = length(var.trusted_service_principals) > 0
    error_message = "trusted_service_principals nao pode ser uma lista vazia; a role precisa de ao menos um principal de confianca explicito."
  }
}

variable "allowed_actions" {
  description = "Lista explicita de actions IAM permitidas pela policy. Wildcards amplos (ex: \"*\" ou \"service:*\") nao sao recomendados."
  type        = list(string)
  default = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions nao pode ser uma lista vazia."
  }

  validation {
    condition     = !contains(var.allowed_actions, "*")
    error_message = "allowed_actions nao deve conter o wildcard \"*\" para todas as actions."
  }
}

variable "resource_arns" {
  description = "Lista de ARNs de recursos aos quais as actions se aplicam. Deve ser especifica, evitando \"*\" como recurso."
  type        = list(string)
  default = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*",
  ]

  validation {
    condition     = length(var.resource_arns) > 0
    error_message = "resource_arns nao pode ser uma lista vazia."
  }

  validation {
    condition     = !contains(var.resource_arns, "*")
    error_message = "resource_arns nao deve conter o wildcard \"*\" isolado como recurso."
  }
}

variable "max_session_duration" {
  description = "Duracao maxima (em segundos) da sessao assumida da role. Entre 3600 (1h) e 43200 (12h)."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "tags" {
  description = "Tags aplicadas a role e a policy."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
  }
}
