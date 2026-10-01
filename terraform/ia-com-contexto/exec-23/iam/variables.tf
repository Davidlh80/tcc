variable "environment" {
  type        = string
  description = "Ambiente de implantacao do recurso. Valores permitidos: dev, hml, prd."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser \"dev\", \"hml\" ou \"prd\"."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema/aplicacao proprietaria do recurso, usado no padrao de nomenclatura."

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  type        = string
  description = "Regiao AWS onde os recursos IAM serao avaliados/criados."
  default     = "us-east-1"
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais a serem mescladas as tags obrigatorias da organizacao."
  default     = {}
}

variable "policy_name" {
  type        = string
  description = "Finalidade da IAM Policy/Role, usada como sufixo no padrao de nomenclatura (ex.: readonly)."

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "policy_name deve conter apenas letras minusculas, numeros e hifens."
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
    error_message = "allowed_resources deve conter ao menos um ARN de recurso."
  }
}

variable "trusted_principal_arn" {
  type        = string
  description = "ARN unico do principal autorizado a assumir a IAM Role (trust policy). Nao pode ser \"*\"."

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws[a-zA-Z0-9-]*:iam::[0-9]{12}:", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM valido (ex.: arn:aws:iam::111122223333:role/nome) e nao pode ser \"*\"."
  }
}
