variable "environment" {
  type        = string
  description = "Ambiente de implantação do recurso."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema/aplicação ao qual o recurso pertence."

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "system não pode ser vazio."
  }
}

variable "region" {
  type        = string
  description = "Região AWS onde o provider será configurado."
  default     = "us-east-1"
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais mescladas às tags obrigatórias da organização."
  default     = {}
}

variable "policy_name" {
  type        = string
  description = "Finalidade da IAM Policy, usada para compor o nome padronizado <ambiente>-<sistema>-iam-<finalidade> (ex.: readonly)."

  validation {
    condition     = length(trimspace(var.policy_name)) > 0
    error_message = "policy_name não pode ser vazio."
  }
}

variable "description" {
  type        = string
  description = "Descrição da IAM Policy."
  default     = "Managed by Terraform."
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de IAM actions permitidas na statement Allow. Não deve conter \"*\" quando allowed_resources também contiver \"*\"."

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma action."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs/recursos permitidos na statement Allow. Não deve conter \"*\" quando allowed_actions também contiver \"*\"."

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }
}
