variable "environment" {
  type        = string
  description = "Ambiente de implantação do recurso."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema ou aplicação associada ao recurso."

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system não pode ser vazio."
  }
}

variable "region" {
  type        = string
  description = "Região AWS onde o provider será configurado."
  default     = "us-east-1"
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais a serem mescladas às tags obrigatórias da organização."
  default     = {}
}

variable "policy_name" {
  type        = string
  description = "Finalidade da IAM Policy, utilizada para compor o nome padronizado (ex.: readonly)."

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "O valor de policy_name não pode ser vazio."
  }
}

variable "policy_description" {
  type        = string
  description = "Descrição da IAM Policy."
  default     = "IAM Policy gerenciada via Terraform."
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de ações IAM permitidas na statement Allow."

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "É necessário informar ao menos uma ação em allowed_actions."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos permitidos na statement Allow."

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "É necessário informar ao menos um recurso em allowed_resources."
  }
}
