variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados (usada apenas para o provider)."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string
  default     = "app-scoped-role"

  validation {
    condition     = length(var.role_name) > 0 && length(var.role_name) <= 64
    error_message = "role_name deve ter entre 1 e 64 caracteres."
  }
}

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "Role com permissoes minimas concedidas via policy dedicada."
}

variable "role_path" {
  description = "Path da IAM Role e da IAM Policy."
  type        = string
  default     = "/"
}

variable "max_session_duration" {
  description = "Duracao maxima (em segundos) da sessao assumida via sts:AssumeRole."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "trusted_service_principals" {
  description = "Lista de service principals da AWS autorizados a assumir a role (trust policy)."
  type        = list(string)
  default     = ["ec2.amazonaws.com"]

  validation {
    condition     = length(var.trusted_service_principals) > 0
    error_message = "Informe ao menos um principal de confianca; a policy nao pode ficar sem principal associado."
  }
}

variable "policy_name" {
  description = "Nome da IAM Policy anexada a role."
  type        = string
  default     = "app-scoped-policy"

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128
    error_message = "policy_name deve ter entre 1 e 128 caracteres."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy com acoes e recursos explicitamente permitidos, sem uso de wildcard amplo."
}

variable "allowed_actions" {
  description = "Lista de acoes IAM explicitamente permitidas pela policy. Evite wildcards amplos como \"*\"."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.allowed_actions) > 0 && !contains(var.allowed_actions, "*")
    error_message = "allowed_actions nao pode ser vazio nem conter o wildcard \"*\"."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos permitidos pela policy. Evite o wildcard \"*\" em producao."
  type        = list(string)
  default     = ["arn:aws:s3:::example-app-bucket", "arn:aws:s3:::example-app-bucket/*"]

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources nao pode ser vazio."
  }
}

variable "tags" {
  description = "Tags aplicadas a role e a policy."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
  }
}
