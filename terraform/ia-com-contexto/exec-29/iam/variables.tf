variable "environment" {
  description = "Ambiente de implantacao do recurso."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome curto do sistema/aplicacao proprietaria do recurso, usado na composicao do nome padronizado."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.system))
    error_message = "system deve conter apenas letras minusculas, numeros e hifens (ex.: tcc)."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "region deve seguir o formato de uma regiao AWS valida (ex.: us-east-1)."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade/nome funcional da IAM Policy e da IAM Role, usado na composicao do nome padronizado <ambiente>-<sistema>-iam-<policy_name> (ex.: readonly, deploy-ci)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.policy_name))
    error_message = "policy_name deve conter apenas letras minusculas, numeros e hifens (ex.: readonly)."
  }
}

variable "trusted_principal_arn" {
  description = "ARN unico do principal autorizado a assumir a IAM Role (sts:AssumeRole). Nao pode ser um wildcard."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:.+$", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM valido e especifico (ex.: arn:aws:iam::123456789012:role/app-role), sem uso de \"*\"."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas na policy (Effect = Allow)."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0 && alltrue([for a in var.allowed_actions : length(trimspace(a)) > 0])
    error_message = "allowed_actions deve conter ao menos uma acao valida, nao vazia."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs/recursos sobre os quais as acoes sao permitidas (Effect = Allow)."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0 && alltrue([for r in var.allowed_resources : length(trimspace(r)) > 0])
    error_message = "allowed_resources deve conter ao menos um recurso valido, nao vazio."
  }
}
