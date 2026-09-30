variable "environment" {
  description = "Ambiente de implantacao do recurso."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser dev, hml ou prd."
  }
}

variable "system" {
  description = "Nome do sistema ou aplicacao proprietaria do recurso."
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
}

variable "policy_name" {
  description = "Finalidade da policy e da role associada, usada na nomenclatura (ex.: readonly, deploy)."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "O valor de policy_name nao pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas as tags obrigatorias."
  type        = map(string)
  default     = {}
}

variable "trusted_principal_arn" {
  description = "ARN do principal (usuario, role ou conta) autorizado a assumir a role via sts:AssumeRole. Nao pode ser curinga (*)."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN valido (ex.: arn:aws:iam::123456789012:role/nome) e nao pode ser \"*\"."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas na policy (Effect Allow). Nao pode conter apenas \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0 && !(length(var.allowed_actions) == 1 && var.allowed_actions[0] == "*")
    error_message = "allowed_actions deve conter ao menos uma acao explicita e nao pode ser somente \"*\"."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos permitidos na policy (Effect Allow). Nao pode conter apenas \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0 && !(length(var.allowed_resources) == 1 && var.allowed_resources[0] == "*")
    error_message = "allowed_resources deve conter ao menos um recurso explicito e nao pode ser somente \"*\"."
  }
}
