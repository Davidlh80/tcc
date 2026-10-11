variable "aws_region" {
  description = "Região AWS onde o provider será configurado."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string
  default     = "app-service-role"
}

variable "role_description" {
  description = "Descrição da IAM Role."
  type        = string
  default     = "Role de aplicacao com permissoes restritas, gerenciada via Terraform."
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada e anexada à role."
  type        = string
  default     = "app-service-policy"
}

variable "policy_description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "Policy com permissoes minimas necessarias, gerenciada via Terraform."
}

variable "path" {
  description = "Path utilizado tanto pela IAM Role quanto pela IAM Policy."
  type        = string
  default     = "/"
}

variable "max_session_duration" {
  description = "Duração máxima (em segundos) da sessão assumida via sts:AssumeRole."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "force_detach_policies" {
  description = "Se true, permite que a role seja destruída mesmo com policies anexadas."
  type        = bool
  default     = false
}

variable "trusted_principal_arn" {
  description = "ARN completo do principal (conta, role ou usuário IAM) autorizado a assumir esta role via sts:AssumeRole. Nunca utilize \"*\" ou um principal irrestrito."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws:iam::\\d{12}:(role|user|root)(/.+)?$", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM válido (conta, role ou usuário) e não pode ser \"*\"."
  }
}

variable "allowed_actions" {
  description = "Lista de ações IAM explicitamente permitidas pela policy. Não utilize ações administrativas amplas nem o wildcard \"*\"."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.allowed_actions) > 0 && !contains(var.allowed_actions, "*")
    error_message = "allowed_actions deve conter ao menos uma ação e não pode incluir o wildcard \"*\"."
  }
}

variable "resource_arns" {
  description = "Lista de ARNs dos recursos sobre os quais as ações da policy serão permitidas. Evite \"*\" sempre que possível."
  type        = list(string)

  validation {
    condition     = length(var.resource_arns) > 0
    error_message = "Informe ao menos um ARN de recurso em resource_arns."
  }
}

variable "tags" {
  description = "Tags aplicadas à IAM Role e à IAM Policy."
  type        = map(string)
  default     = {}
}
