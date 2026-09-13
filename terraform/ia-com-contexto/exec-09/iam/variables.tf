variable "environment" {
  type        = string
  description = "Ambiente de implantacao do recurso (dev, hml ou prd)."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema ou aplicacao ao qual o recurso pertence."

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  type        = string
  description = "Regiao AWS onde o provider sera configurado."
  default     = "us-east-1"
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais a serem mescladas as tags obrigatorias da organizacao."
  default     = {}
}

variable "policy_name" {
  type        = string
  description = "Finalidade da IAM Policy, usada para compor o nome do recurso (ex.: readonly, deploy)."

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "O valor de policy_name nao pode ser vazio."
  }
}

variable "policy_description" {
  type        = string
  description = "Descricao associada a IAM Policy."
  default     = "Managed by Terraform."
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de actions IAM permitidas na statement Allow. Nao e permitido o valor \"*\" isolado na lista."

  validation {
    condition     = length(var.allowed_actions) > 0 && !contains(var.allowed_actions, "*")
    error_message = "allowed_actions deve conter ao menos uma action explicita e nao pode conter o valor \"*\"."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos permitidos na statement Allow. Nao e permitido o valor \"*\" isolado na lista."

  validation {
    condition     = length(var.allowed_resources) > 0 && !contains(var.allowed_resources, "*")
    error_message = "allowed_resources deve conter ao menos um recurso explicito e nao pode conter o valor \"*\"."
  }
}
