variable "environment" {
  type        = string
  description = "Ambiente de implantação dos recursos. Valores permitidos: dev, hml, prd."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Nome curto do sistema/aplicação dono do recurso, usado no padrão de nomenclatura."

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system))
    error_message = "system deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "region" {
  type        = string
  description = "Região AWS onde os recursos serão provisionados."
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "region deve ser uma região AWS válida, ex.: us-east-1."
  }
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais a serem mescladas com as tags obrigatórias da organização."
  default     = {}
}

variable "policy_name" {
  type        = string
  description = "Finalidade da IAM Policy, usada no padrão <ambiente>-<sistema>-iam-<finalidade>."

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "policy_name deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "role_name" {
  type        = string
  description = "Finalidade da IAM Role, usada no padrão <ambiente>-<sistema>-iam-<finalidade>."

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.role_name))
    error_message = "role_name deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de actions IAM permitidas na policy (Effect = Allow). Não pode ser combinada com allowed_resources contendo \"*\" simultaneamente."

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma action IAM válida."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos aos quais as actions permitidas se aplicam (Effect = Allow)."

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um ARN de recurso válido."
  }
}

variable "trusted_principal_arn" {
  type        = string
  description = "ARN do principal (IAM User/Role) ou service principal (*.amazonaws.com) autorizado a assumir a role via trust policy. Não pode ser \"*\"."

  validation {
    condition = (
      var.trusted_principal_arn != "*" &&
      (
        can(regex("^arn:aws:iam::[0-9]{12}:(user|role)/.+$", var.trusted_principal_arn)) ||
        can(regex("^[a-z0-9.-]+\\.amazonaws\\.com$", var.trusted_principal_arn))
      )
    )
    error_message = "trusted_principal_arn deve ser um ARN de IAM User/Role válido ou um service principal (*.amazonaws.com), e não pode ser \"*\"."
  }
}

variable "max_session_duration" {
  type        = number
  description = "Duração máxima (em segundos) da sessão assumida via sts:AssumeRole."
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}
