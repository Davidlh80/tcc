variable "environment" {
  type        = string
  description = "Ambiente de implantacao do recurso."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser 'dev', 'hml' ou 'prd'."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema ou produto ao qual o recurso pertence."

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  type        = string
  description = "Regiao AWS onde os recursos serao criados."
  default     = "us-east-1"
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  default     = {}
}

variable "policy_name" {
  type        = string
  description = "Finalidade da IAM Policy/Role, usada na composicao do nome padronizado (ex.: 'readonly')."

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "O valor de policy_name nao pode ser vazio."
  }
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de IAM Actions permitidas na statement Allow da policy."

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma action."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos permitidos na statement Allow da policy."

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um resource."
  }

  validation {
    condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
    error_message = "Nao e permitido combinar Action = \"*\" com Resource = \"*\" na mesma statement."
  }
}

variable "trusted_principal_arn" {
  type        = string
  description = "ARN do principal (conta, role ou usuario IAM) autorizado a assumir a Role via sts:AssumeRole."

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws:iam::[0-9]{12}:(root|user/.+|role/.+)$", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM valido (root, user/... ou role/...) e nao pode ser \"*\"."
  }
}
