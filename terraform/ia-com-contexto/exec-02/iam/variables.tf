variable "environment" {
  description = "Ambiente de implantacao do recurso."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema/aplicacao proprietario do recurso, usado na nomenclatura padronizada."
  type        = string

  validation {
    condition     = length(var.system) > 0
    error_message = "system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos serao criados."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "region deve seguir o formato de uma regiao AWS valida, ex.: us-east-1."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade/identificador do recurso IAM (ex.: readonly, s3-access), usado na nomenclatura padronizada da policy e da role."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "policy_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "trusted_principal_arn" {
  description = "ARN do principal (IAM role, usuario ou conta) autorizado a assumir a IAM Role via trust policy. Nao pode ser \"*\"."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws:iam::[0-9]{12}:.+$", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM valido (ex.: arn:aws:iam::123456789012:role/nome) e nao pode ser \"*\"."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas na statement Allow da policy (principio do menor privilegio)."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma acao IAM."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos permitidos na statement Allow da policy (principio do menor privilegio)."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um ARN de recurso."
  }
}
