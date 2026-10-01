variable "aws_region" {
  description = "Regiao AWS onde o provider ira operar."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string
  default     = "app-role"

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,64}$", var.role_name))
    error_message = "role_name deve ter entre 1 e 64 caracteres validos para nomes de IAM Role (letras, numeros e + = , . @ _ -)."
  }
}

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "Role de aplicacao com permissoes minimas de logging."
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

variable "permissions_boundary_arn" {
  description = "ARN de uma policy a ser usada como permissions boundary da role. Deixe null para nao aplicar boundary."
  type        = string
  default     = null
}

variable "force_detach_policies" {
  description = "Se verdadeiro, forca o desanexo de policies ao destruir a role."
  type        = bool
  default     = true
}

variable "trusted_service_principals" {
  description = "Lista de service principals da AWS autorizados a assumir a role (ex.: ec2.amazonaws.com). Pelo menos um principal (service ou AWS) deve ser informado."
  type        = list(string)
  default     = ["ec2.amazonaws.com"]
}

variable "trusted_aws_principals" {
  description = "Lista de ARNs de contas ou principals AWS autorizados a assumir a role. Pelo menos um principal (service ou AWS) deve ser informado."
  type        = list(string)
  default     = []
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada e anexada a role."
  type        = string
  default     = "app-role-policy"

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,128}$", var.policy_name))
    error_message = "policy_name deve ter entre 1 e 128 caracteres validos para nomes de IAM Policy (letras, numeros e + = , . @ _ -)."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy com permissoes minimas de CloudWatch Logs, escopada a um log group especifico."
}

variable "log_group_name" {
  description = "Nome do CloudWatch Log Group ao qual as permissoes da policy serao restritas."
  type        = string
  default     = "/app/example"
}

variable "policy_actions" {
  description = "Lista de actions IAM permitidas pela policy, restritas ao recurso definido por log_group_name. Nao utilize wildcards amplos (ex.: \"*\")."
  type        = list(string)
  default = [
    "logs:CreateLogGroup",
    "logs:CreateLogStream",
    "logs:PutLogEvents",
  ]

  validation {
    condition     = length(var.policy_actions) > 0
    error_message = "policy_actions deve conter ao menos uma action."
  }
}

variable "tags" {
  description = "Tags aplicadas a role e a policy."
  type        = map(string)
  default     = {}
}
