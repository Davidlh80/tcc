variable "environment" {
  description = "Ambiente de implantacao do recurso."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de 'environment' deve ser 'dev', 'hml' ou 'prd'."
  }
}

variable "system" {
  description = "Nome curto do sistema ou produto ao qual o recurso pertence, usado no padrao de nomenclatura."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.system))
    error_message = "O valor de 'system' deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos serao criados."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da policy, usada no padrao de nomenclatura <ambiente>-<sistema>-iam-policy-<finalidade> e <ambiente>-<sistema>-iam-role-<finalidade>."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.policy_name))
    error_message = "O valor de 'policy_name' deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "trusted_principal_arn" {
  description = "ARN unico do principal (usuario, role ou conta) autorizado a assumir a IAM Role criada. Nao e permitido usar '*'."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:(iam|sts)::[0-9]{12}:.+$", var.trusted_principal_arn))
    error_message = "O valor de 'trusted_principal_arn' deve ser um ARN valido de usuario, role ou conta IAM (ex.: arn:aws:iam::123456789012:role/nome)."
  }
}

variable "allowed_actions" {
  description = "Lista de actions IAM permitidas na statement Allow da policy."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "A variavel 'allowed_actions' deve conter ao menos uma action."
  }
}

variable "allowed_resources" {
  description = "Lista de recursos (ARNs) permitidos na statement Allow da policy."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "A variavel 'allowed_resources' deve conter ao menos um recurso."
  }
}
