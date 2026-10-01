variable "environment" {
  description = "Ambiente de implantação do recurso."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser 'dev', 'hml' ou 'prd'."
  }
}

variable "system" {
  description = "Nome do sistema ou aplicação ao qual este recurso pertence."
  type        = string
  default     = "tcc"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system))
    error_message = "O valor de system deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "region" {
  description = "Região AWS onde os recursos serão provisionados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "O valor de region deve corresponder a uma região AWS válida, ex.: us-east-1."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatórias. Não é possível sobrescrever as tags obrigatórias."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da policy/role, usada para compor o nome no padrão <ambiente>-<sistema>-iam-<finalidade>."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "O valor de policy_name deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "policy_description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "Policy gerenciada por Terraform com permissoes restritas ao menor privilegio necessario."
}

variable "trusted_principal_arn" {
  description = "ARN do principal (role, user ou root da conta) autorizado a assumir esta Role via trust policy. Não é permitido usar '*'."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z0-9-]*:iam::[0-9]{12}:(root|(role|user)/.+)$", var.trusted_principal_arn))
    error_message = "O valor de trusted_principal_arn deve ser um ARN IAM valido (role, user ou root) e nao pode ser '*'."
  }
}

variable "allowed_actions" {
  description = "Lista de ações IAM permitidas na policy. Não é permitido usar '*'."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0 && !contains(var.allowed_actions, "*") && alltrue([for a in var.allowed_actions : can(regex("^[a-zA-Z0-9]+:[A-Za-z0-9*]+$", a))])
    error_message = "allowed_actions deve conter ao menos uma acao, nao pode conter '*' e cada acao deve seguir o formato 'servico:Acao'."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos permitidos na policy. Não é permitido usar '*'."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0 && !contains(var.allowed_resources, "*") && alltrue([for r in var.allowed_resources : can(regex("^arn:", r))])
    error_message = "allowed_resources deve conter ao menos um ARN, nao pode conter '*' e cada recurso deve iniciar com 'arn:'."
  }
}

variable "max_session_duration" {
  description = "Duração máxima (em segundos) da sessão assumida da Role."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}
