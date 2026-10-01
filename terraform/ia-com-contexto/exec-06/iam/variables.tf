variable "environment" {
  description = "Ambiente de implantacao do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome curto do sistema/aplicacao ao qual o recurso pertence (usado na nomenclatura)."
  type        = string

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos serao criados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(var.region) > 0
    error_message = "O valor de region nao pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da IAM Policy/Role, usada no padrao de nomenclatura <ambiente>-<sistema>-iam-<finalidade>."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "O valor de policy_name nao pode ser vazio."
  }
}

variable "trusted_principal_arn" {
  description = "ARN unico do principal autorizado a assumir a IAM Role (trust policy). Nao pode ser \"*\"."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws:iam::[0-9]{12}:.+$", var.trusted_principal_arn))
    error_message = "O valor de trusted_principal_arn deve ser um ARN IAM valido no formato arn:aws:iam::<account-id>:<recurso> e nao pode ser \"*\"."
  }
}

variable "allowed_actions" {
  description = "Lista de actions IAM permitidas (Effect = Allow) na policy."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "A lista allowed_actions deve conter ao menos uma action."
  }
}

variable "allowed_resources" {
  description = "Lista de recursos (ARNs) aos quais as allowed_actions se aplicam."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "A lista allowed_resources deve conter ao menos um recurso."
  }
}
