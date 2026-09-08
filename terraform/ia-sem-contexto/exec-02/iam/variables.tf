variable "aws_region" {
  description = "Regiao AWS onde o provider ira operar."
  type        = string
  default     = "us-east-1"
  validation {
    condition     = can(regex("^[a-z]{2}(-gov)?-[a-z]+-[0-9]$", var.aws_region))
    error_message = "aws_region deve seguir o padrao '<cc>-<nome>-<n>'. Exemplos validos: us-east-1, eu-west-1, sa-east-1, us-gov-west-1."
  }
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada."
  type        = string
  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]{1,128}$", var.policy_name))
    error_message = "policy_name deve conter de 1 a 128 caracteres validos (A-Za-z0-9+=,.@_-)."
  }
}

variable "policy_path" {
  description = "Caminho (path) da policy. Deve comecar e terminar com '/'. Use '/' para raiz."
  type        = string
  default     = "/"
  validation {
    condition     = var.policy_path == "/" || can(regex("^/.+/$", var.policy_path))
    error_message = "policy_path deve ser '/' ou iniciar e terminar com '/'. Ex.: '/', '/service/', '/customer-managed/'."
  }
}

variable "description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "IAM policy gerenciada pelo Terraform."
}

variable "policy_effect" {
  description = "Efeito da declaracao da policy (Allow ou Deny)."
  type        = string
  default     = "Allow"
  validation {
    condition     = contains(["Allow", "Deny"], var.policy_effect)
    error_message = "policy_effect deve ser 'Allow' ou 'Deny'."
  }
}

variable "statement_sid" {
  description = "Identificador (SID) da declaracao principal da policy."
  type        = string
  default     = "PrimaryStatement"
  validation {
    condition     = can(regex("^[A-Za-z0-9]{1,128}$", var.statement_sid))
    error_message = "statement_sid deve conter apenas caracteres alfanumericos, com ate 128 caracteres."
  }
}

variable "actions" {
  description = "Lista de acoes AWS permitidas/negadas (ex.: ['s3:ListBucket', 's3:GetObject'])."
  type        = list(string)
  validation {
    condition     = length(var.actions) > 0
    error_message = "Defina ao menos uma acao em 'actions'."
  }
}

variable "resource_arns" {
  description = "Lista de ARNs dos recursos aos quais as acoes se aplicam (ex.: ['arn:aws:s3:::meu-bucket', 'arn:aws:s3:::meu-bucket/*'])."
  type        = list(string)
  validation {
    condition     = length(var.resource_arns) > 0
    error_message = "Defina ao menos um ARN em 'resource_arns'."
  }
}

variable "conditions" {
  description = "Lista opcional de condicionais IAM. Cada item deve conter test, variable e values."
  type = list(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  default = []
}

variable "tags" {
  description = "Tags adicionais para a IAM Policy."
  type        = map(string)
  default     = {}
}
