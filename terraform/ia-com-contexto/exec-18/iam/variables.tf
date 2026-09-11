variable "environment" {
  description = "Ambiente alvo (dev, hml, prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/aplicacao (minusculo, numeros e hifens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas [a-z0-9-] e nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS para o provider."
  type        = string

  validation {
    condition     = length(var.region) > 0
    error_message = "region nao pode ser vazia."
  }
}

variable "additional_tags" {
  description = "Mapa de tags adicionais a serem aplicadas ao recurso."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da policy (parte final do nome padronizado). Ex.: readonly, s3-access."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name)) && length(var.policy_name) > 0
    error_message = "policy_name deve conter apenas [a-z0-9-] e nao pode ser vazio."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes AWS permitidas (ex.: [\"s3:GetObject\", \"s3:ListBucket\"])."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma acao."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos permitidos (pode incluir \"*\")."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso ou \"*\"."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Managed IAM policy aligned with organizational least-privilege guidance."
}

variable "policy_path" {
  description = "Caminho da policy IAM. Deve iniciar e terminar com '/'."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/.*$", var.policy_path)) && endswith(var.policy_path, "/")
    error_message = "policy_path deve iniciar e terminar com '/'. Ex.: '/app/' ou '/'."
  }
}

variable "conditions" {
  description = "Lista opcional de condicoes IAM para a statement Allow."
  type = list(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  default = []
}
