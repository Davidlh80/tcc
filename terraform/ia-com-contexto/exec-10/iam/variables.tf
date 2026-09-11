variable "environment" {
  description = "Ambiente onde o recurso sera provisionado. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/projeto (minusculo, alfanumerico e hifens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas [a-z0-9-] e nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde o provider sera configurado (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d+$", var.region))
    error_message = "region deve seguir o padrao de regioes AWS, por exemplo: us-east-1."
  }
}

variable "policy_name" {
  description = "Finalidade da policy (sera usada no padrao de nomenclatura <environment>-<system>-iam-<policy_name>)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name)) && length(var.policy_name) > 0
    error_message = "policy_name deve conter apenas [a-z0-9-] e nao pode ser vazio."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes permitidas (Effect: Allow). Nao permita combinacao de Action: * com Resource: *."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions nao pode ser vazio."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos permitidos (Effect: Allow). Nao permita combinacao de Action: * com Resource: *."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources nao pode ser vazio."
  }
}

variable "policy_description" {
  description = "Descricao da policy IAM."
  type        = string
  default     = null

  validation {
    condition     = var.policy_description == null || length(var.policy_description) <= 1000
    error_message = "policy_description deve ter no maximo 1000 caracteres."
  }
}

variable "policy_path" {
  description = "Caminho (path) da policy IAM. Deve iniciar e terminar com '/'."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/.*/?$", var.policy_path))
    error_message = "policy_path deve iniciar com '/' e preferencialmente terminar com '/'."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas (chaves obrigatorias serao mantidas pelos padroes organizacionais)."
  type        = map(string)
  default     = {}
}
