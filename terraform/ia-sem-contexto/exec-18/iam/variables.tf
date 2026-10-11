variable "aws_region" {
  description = "Região AWS onde o provider será configurado."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string

  validation {
    condition     = length(var.role_name) > 0 && length(var.role_name) <= 64
    error_message = "role_name deve ter entre 1 e 64 caracteres."
  }
}

variable "role_description" {
  description = "Descrição da IAM Role."
  type        = string
  default     = "IAM Role gerenciada via Terraform."
}

variable "role_path" {
  description = "Path da IAM Role."
  type        = string
  default     = "/"
}

variable "max_session_duration" {
  description = "Duração máxima, em segundos, de uma sessão assumida via sts:AssumeRole."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "trusted_principal_arns" {
  description = "Lista de ARNs de principals (roles, users ou contas) autorizados a assumir esta role via sts:AssumeRole. O valor \"*\" (qualquer principal) não é permitido."
  type        = list(string)

  validation {
    condition     = length(var.trusted_principal_arns) > 0
    error_message = "trusted_principal_arns deve conter ao menos um principal."
  }

  validation {
    condition     = alltrue([for p in var.trusted_principal_arns : p != "*"])
    error_message = "trusted_principal_arns não pode conter o valor \"*\" (qualquer principal)."
  }
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128
    error_message = "policy_name deve ter entre 1 e 128 caracteres."
  }
}

variable "policy_description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "IAM Policy gerenciada via Terraform."
}

variable "policy_path" {
  description = "Path da IAM Policy."
  type        = string
  default     = "/"
}

variable "policy_actions" {
  description = "Lista de actions permitidas pela policy. O uso de \"*\" (todas as actions) não é permitido."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.policy_actions) > 0
    error_message = "policy_actions deve conter ao menos uma action."
  }

  validation {
    condition     = alltrue([for a in var.policy_actions : a != "*"])
    error_message = "policy_actions não pode conter o valor \"*\" (todas as actions)."
  }
}

variable "policy_resources" {
  description = "Lista de ARNs de recursos aos quais as actions da policy se aplicam. O uso de \"*\" (qualquer recurso) não é permitido."
  type        = list(string)

  validation {
    condition     = length(var.policy_resources) > 0
    error_message = "policy_resources deve conter ao menos um recurso."
  }

  validation {
    condition     = alltrue([for r in var.policy_resources : r != "*"])
    error_message = "policy_resources não pode conter o valor \"*\" (qualquer recurso)."
  }
}

variable "tags" {
  description = "Tags aplicadas à IAM Role e à IAM Policy."
  type        = map(string)
  default     = {}
}
