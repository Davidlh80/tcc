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
  description = "Nome do sistema ou projeto ao qual o recurso pertence."
  default     = "tcc"

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  type        = string
  description = "Regiao AWS onde os recursos serao provisionados."
  default     = "us-east-1"
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais a serem mescladas as tags obrigatorias do recurso."
  default     = {}
}

variable "policy_name" {
  type        = string
  description = "Finalidade da policy, utilizada para compor o nome padronizado (ex.: readonly, deploy)."

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "O valor de policy_name nao pode ser vazio."
  }
}

variable "policy_description" {
  type        = string
  description = "Descricao da IAM Policy."
  default     = "Policy gerenciada via Terraform seguindo o principio do menor privilegio."
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de actions IAM permitidas na statement Allow (menor privilegio)."

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "Informe ao menos uma action em allowed_actions."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos permitidos na statement Allow."

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "Informe ao menos um resource (ARN) em allowed_resources."
  }
}
