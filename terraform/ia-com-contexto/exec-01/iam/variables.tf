variable "environment" {
  description = "Ambiente de implantacao do recurso."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou aplicacao dona do recurso, usado na nomenclatura padronizada."
  type        = string

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "O valor de region deve seguir o formato de uma regiao AWS valida, ex.: us-east-1."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da policy, usada como ultimo segmento do padrao de nomenclatura <ambiente>-<sistema>-iam-<finalidade>."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "O valor de policy_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy gerenciada via Terraform com escopo restrito de acoes e recursos."
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas na statement Allow da policy."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "A lista allowed_actions deve conter pelo menos uma acao."
  }
}

variable "allowed_resources" {
  description = "Lista de recursos (ARNs) aos quais as acoes permitidas se aplicam."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "A lista allowed_resources deve conter pelo menos um recurso."
  }
}
