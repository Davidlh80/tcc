variable "environment" {
  type        = string
  description = "Ambiente de implantacao do recurso. Valores permitidos: dev, hml, prd."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "A variavel 'environment' deve ser um dos seguintes valores: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema/aplicacao ao qual este recurso pertence, usado na nomenclatura padronizada."

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "A variavel 'system' nao pode ser vazia."
  }
}

variable "region" {
  type        = string
  description = "Regiao AWS utilizada para configurar o provider."
  default     = "us-east-1"
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  default     = {}
}

variable "policy_name" {
  type        = string
  description = "Finalidade/identificador da IAM Policy e da IAM Role, usado na nomenclatura padronizada (ex.: 'readonly')."

  validation {
    condition     = length(trimspace(var.policy_name)) > 0
    error_message = "A variavel 'policy_name' nao pode ser vazia."
  }
}

variable "trusted_principal_arn" {
  type        = string
  description = "ARN unico do principal (conta, usuario ou role) autorizado a assumir a IAM Role criada. Nao e permitido usar '*'."

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws:iam::\\d{12}:(root|user/.+|role/.+)$", var.trusted_principal_arn))
    error_message = "A variavel 'trusted_principal_arn' deve ser um ARN IAM valido no formato arn:aws:iam::<account-id>:root|user/<nome>|role/<nome>, e nao pode ser '*'."
  }
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de acoes IAM permitidas (Effect Allow) na policy. Nao pode conter '*' quando 'allowed_resources' tambem contiver '*'."

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "A variavel 'allowed_actions' deve conter pelo menos uma acao."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs/recursos permitidos (Effect Allow) na policy. Nao pode conter '*' quando 'allowed_actions' tambem contiver '*'."

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "A variavel 'allowed_resources' deve conter pelo menos um recurso."
  }
}
