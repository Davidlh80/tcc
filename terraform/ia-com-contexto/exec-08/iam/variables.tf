variable "environment" {
  description = "Ambiente de implantacao do recurso (dev, hml ou prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser dev, hml ou prd."
  }
}

variable "system" {
  description = "Nome do sistema ou aplicacao ao qual o recurso pertence."
  type        = string

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas as tags obrigatorias do recurso."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da IAM Policy/Role, usada para compor o nome padronizado (ex.: readonly, deploy)."
  type        = string

  validation {
    condition     = length(trimspace(var.policy_name)) > 0
    error_message = "O valor de policy_name nao pode ser vazio."
  }
}

variable "allowed_actions" {
  description = "Lista de IAM Actions permitidas na policy (statement com Effect Allow)."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter pelo menos uma action."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs (ou \"*\") de recursos permitidos na policy (statement com Effect Allow)."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter pelo menos um recurso."
  }
}

variable "trusted_principal_arn" {
  description = "ARN unico do principal (role, user ou root) autorizado a assumir a IAM Role via trust policy."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z0-9-]*:iam::\\d{12}:(role|user|root)", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM valido, no formato arn:aws:iam::<account-id>:role|user/<nome> ou arn:aws:iam::<account-id>:root."
  }
}
