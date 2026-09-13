variable "environment" {
  description = "Ambiente de implantacao do recurso. Deve ser um dos ambientes permitidos pela organizacao."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou produto ao qual o recurso pertence, utilizado na nomenclatura padronizada."
  type        = string

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
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
  description = "Finalidade da IAM Policy, utilizada na composicao do nome padronizado (ex.: readonly, deploy, logs)."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "O valor de policy_name nao pode ser vazio."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "IAM Policy gerenciada via Terraform seguindo o padrao organizacional."
}

variable "allowed_actions" {
  description = "Lista de actions IAM permitidas na statement Allow da policy. Nao pode conter \"*\" combinado com allowed_resources contendo \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "O valor de allowed_actions deve conter ao menos uma action."
  }
}

variable "allowed_resources" {
  description = "Lista de recursos (ARNs) permitidos na statement Allow da policy. Nao pode conter \"*\" combinado com allowed_actions contendo \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "O valor de allowed_resources deve conter ao menos um recurso."
  }
}
