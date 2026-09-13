variable "environment" {
  description = "Ambiente de implantacao do recurso."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou aplicacao dono do recurso, utilizado na nomenclatura padronizada."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system))
    error_message = "O valor de system deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da IAM Policy, utilizada na nomenclatura padronizada (<ambiente>-<sistema>-iam-<finalidade>)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "O valor de policy_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "IAM Policy gerenciada via Terraform seguindo o padrao organizacional de menor privilegio."
}

variable "allowed_actions" {
  description = "Lista de actions IAM permitidas na statement Allow da policy. Nao pode conter '*' combinado com allowed_resources = ['*']."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "A lista allowed_actions deve conter ao menos uma action."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos permitidos na statement Allow da policy. Nao pode conter '*' combinado com allowed_actions = ['*']."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "A lista allowed_resources deve conter ao menos um recurso."
  }
}
