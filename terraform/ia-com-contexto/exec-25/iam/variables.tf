variable "environment" {
  description = "Ambiente de implantacao do recurso."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou produto ao qual o recurso pertence, utilizado na composicao do nome padronizado."
  type        = string

  validation {
    condition     = length(var.system) > 0
    error_message = "A variavel system nao pode ser vazia."
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
  description = "Finalidade/nome da policy e da role, utilizado na composicao do nome padronizado (ex.: readonly, logs-write)."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "A variavel policy_name nao pode ser vazia."
  }
}

variable "trusted_principal_arn" {
  description = "ARN unico do principal (usuario, role ou conta) autorizado a assumir a IAM Role. Nao e permitido \"*\"."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws[a-zA-Z-]*:iam::\\d{12}:(root|user/.+|role/.+)$", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM valido e especifico (root, user ou role de uma conta). Nao e permitido \"*\"."
  }
}

variable "allowed_actions" {
  description = "Lista de actions IAM permitidas na policy (Effect Allow)."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma action."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos permitidos na policy (Effect Allow)."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um ARN de recurso."
  }
}
