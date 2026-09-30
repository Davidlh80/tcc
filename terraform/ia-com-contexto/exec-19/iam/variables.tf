variable "environment" {
  description = "Ambiente de implantacao do recurso."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser 'dev', 'hml' ou 'prd'."
  }
}

variable "system" {
  description = "Nome do sistema/aplicacao proprietaria do recurso, usado na nomenclatura padrao."
  type        = string

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde o provider ira operar."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "O valor de region deve ser uma regiao AWS valida, por exemplo: us-east-1."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da IAM Policy/Role, utilizada na nomenclatura padrao <ambiente>-<sistema>-<recurso>-<finalidade>."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "O valor de policy_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "trusted_principal_arn" {
  description = "ARN do principal (conta, usuario ou role) autorizado a assumir a IAM Role. Nao e permitido usar '*'."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws:iam::[0-9]{12}:(root|user/.+|role/.+)$", var.trusted_principal_arn))
    error_message = "O valor de trusted_principal_arn deve ser um ARN IAM valido (conta root, usuario ou role) e nao pode ser '*'."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas na statement Allow da policy."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "O valor de allowed_actions nao pode ser uma lista vazia."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos permitidos na statement Allow da policy. Proibida a combinacao Action:'*' com Resource:'*'."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0 && !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
    error_message = "Combinacao proibida: allowed_actions e allowed_resources nao podem conter '*' simultaneamente, e allowed_resources nao pode ser uma lista vazia."
  }
}
