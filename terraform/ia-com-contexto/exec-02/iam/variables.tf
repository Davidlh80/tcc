variable "region" {
  description = "Regiao AWS onde os recursos serao gerenciados."
  type        = string
  nullable    = false

  validation {
    condition     = length(var.region) > 0
    error_message = "A variavel region deve ser informada (ex.: us-east-1)."
  }
}

variable "environment" {
  description = "Ambiente do recurso (valores permitidos: dev, hml, prd)."
  type        = string
  nullable    = false

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml ou prd."
  }
}

variable "system" {
  description = "Identificador do sistema/produto (ex.: tcc). Use letras minusculas, numeros e hifens."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas [a-z0-9-] e nao pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas ao recurso (serao mescladas com as tags obrigatorias)."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade/nome curto da policy para compor a nomenclatura padrao (<env>-<system>-iam-<policy_name>)."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name)) && length(var.policy_name) > 0
    error_message = "policy_name deve conter apenas [a-z0-9-] e nao pode ser vazio."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos aos quais as acoes serao permitidas."
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources nao pode ser vazio."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes IAM a serem permitidas (principio do menor privilegio)."
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions nao pode ser vazio."
  }

  validation {
    condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
    error_message = "Proibido combinar Action: \"*\" com Resource: \"*\" na mesma statement (política interna de IAM)."
  }
}

variable "allowed_conditions" {
  description = "Lista opcional de condicoes para a statement Allow. Cada condicao deve conter test, variable e values."
  type = list(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  default = []
}

variable "description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Managed IAM policy with scoped permissions aligned to organizational standards."
}

variable "path" {
  description = "Caminho da IAM Policy."
  type        = string
  default     = "/"
}
