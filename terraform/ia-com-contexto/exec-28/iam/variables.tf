variable "environment" {
  description = "Ambiente de implantacao. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome curto do sistema/aplicacao dono do recurso, usado no padrao de nomenclatura."
  type        = string

  validation {
    condition     = length(var.system) > 0
    error_message = "A variavel system nao pode ser vazia."
  }
}

variable "region" {
  description = "Regiao AWS onde o provider sera configurado."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade/nome da IAM Policy e da IAM Role, usado no padrao <ambiente>-<sistema>-<recurso>-<finalidade> (ex.: readonly)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "policy_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas (Effect = Allow) na policy. Nao pode ser combinada com allowed_resources contendo '*' simultaneamente."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma acao."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs/recursos permitidos (Effect = Allow) na policy. Nao pode ser combinada com allowed_actions contendo '*' simultaneamente."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }
}

variable "trusted_principal_arn" {
  description = "ARN unico do principal (role, user ou root de conta) autorizado a assumir a IAM Role via sts:AssumeRole. Nao aceita wildcard."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:(role|user|root)(/.*)?$", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM valido (role, user ou root) e nao pode ser \"*\"."
  }
}
