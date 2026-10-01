variable "environment" {
  description = "Ambiente de implantacao do recurso."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema/projeto ao qual o recurso pertence, usado no padrao de nomenclatura."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system))
    error_message = "O valor de system deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Nome completo da IAM Policy, seguindo o padrao <ambiente>-<sistema>-iam-<finalidade>."
  type        = string

  validation {
    condition     = can(regex("^(dev|hml|prd)-[a-z0-9-]+-iam-[a-z0-9-]+$", var.policy_name))
    error_message = "O valor de policy_name deve seguir o padrao <ambiente>-<sistema>-iam-<finalidade>, ex.: prd-tcc-iam-readonly."
  }
}

variable "role_name" {
  description = "Nome completo da IAM Role, seguindo o padrao <ambiente>-<sistema>-iam-role-<finalidade>."
  type        = string

  validation {
    condition     = can(regex("^(dev|hml|prd)-[a-z0-9-]+-iam-role-[a-z0-9-]+$", var.role_name))
    error_message = "O valor de role_name deve seguir o padrao <ambiente>-<sistema>-iam-role-<finalidade>, ex.: prd-tcc-iam-role-readonly."
  }
}

variable "assume_role_principal_arn" {
  description = "ARN do principal (conta, role ou usuario IAM) ou service principal autorizado a assumir a role. Nao pode ser um wildcard."
  type        = string

  validation {
    condition = (
      var.assume_role_principal_arn != "*" &&
      can(regex("^(arn:aws:(iam|sts)::[0-9]{12}:.+|[a-z0-9.-]+\\.amazonaws\\.com)$", var.assume_role_principal_arn))
    )
    error_message = "O valor de assume_role_principal_arn deve ser um ARN de conta/role/usuario IAM valido ou um service principal (ex.: ec2.amazonaws.com), e nao pode ser \"*\"."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas na policy. Nao pode conter o wildcard \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0 && !contains(var.allowed_actions, "*")
    error_message = "O valor de allowed_actions deve conter ao menos uma acao e nao pode incluir o wildcard \"*\"."
  }
}

variable "allowed_resources" {
  description = "Lista de recursos (ARNs) permitidos na policy. Nao pode conter o wildcard \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0 && !contains(var.allowed_resources, "*")
    error_message = "O valor de allowed_resources deve conter ao menos um recurso e nao pode incluir o wildcard \"*\"."
  }
}
