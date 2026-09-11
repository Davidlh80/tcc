variable "environment" {
  description = "Ambiente de implantação do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema (componente/aplicação) responsável pelo recurso."
  type        = string

  validation {
    condition     = length(var.system) > 0 && can(regex("^[a-z0-9-]+$", var.system))
    error_message = "system deve conter apenas letras minúsculas, números e hífens, e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS onde os recursos serão gerenciados."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d+$", var.region))
    error_message = "region deve estar no formato válido (ex.: us-east-1, sa-east-1)."
  }
}

variable "additional_tags" {
  description = "Mapa de tags adicionais a serem aplicadas ao recurso."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da policy conforme padrão de nomenclatura (ex.: readonly, s3-access). Será usada como sufixo em <environment>-<system>-iam-<policy_name>."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0 && can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "policy_name deve conter apenas letras minúsculas, números e hífens, e não pode ser vazio."
  }
}

variable "allowed_actions" {
  description = "Lista de ações explícitas a serem permitidas pela policy (ex.: [\"s3:GetObject\", \"s3:ListBucket\"])."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0 && alltrue([for a in var.allowed_actions : length(trim(a)) > 0])
    error_message = "allowed_actions não pode ser vazio e não pode conter strings vazias."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs dos recursos aos quais as ações serão permitidas (ex.: [\"arn:aws:s3:::meu-bucket\", \"arn:aws:s3:::meu-bucket/*\"]). Pode incluir \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0 && alltrue([for r in var.allowed_resources : length(trim(r)) > 0])
    error_message = "allowed_resources não pode ser vazio e não pode conter strings vazias."
  }
}

variable "policy_description" {
  description = "Descrição opcional da policy IAM."
  type        = string
  default     = null
}

variable "policy_path" {
  description = "Caminho da policy IAM (por exemplo, \"/\" ou \"/service-role/\")."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/.*/?$", var.policy_path))
    error_message = "policy_path deve iniciar com \"/\" e opcionalmente terminar com \"/\"."
  }
}
