variable "region" {
  description = "Regiao AWS utilizada pelo provider."
  type        = string
  default     = "us-east-1"
}

variable "policy_name" {
  description = "Nome da IAM Policy."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128
    error_message = "policy_name deve ter entre 1 e 128 caracteres."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Gerenciada via Terraform."
}

variable "path" {
  description = "Path da IAM Policy. Deve iniciar e terminar com '/'."
  type        = string
  default     = "/"

  validation {
    condition     = var.path == "/" || can(regex("^/.*/$", var.path))
    error_message = "path deve comecar e terminar com '/', por exemplo '/' ou '/servico/'."
  }
}

variable "effect" {
  description = "Efeito da statement da policy (Allow ou Deny)."
  type        = string
  default     = "Allow"

  validation {
    condition     = contains(["Allow", "Deny"], var.effect)
    error_message = "effect deve ser 'Allow' ou 'Deny'."
  }
}

variable "actions" {
  description = "Lista de actions IAM permitidas ou negadas pela policy. Prefira acoes explicitas em vez de wildcard."
  type        = list(string)

  validation {
    condition     = length(var.actions) > 0
    error_message = "actions deve conter ao menos um item."
  }
}

variable "resources" {
  description = "Lista de ARNs de recursos aos quais a policy se aplica. Prefira ARNs explicitos em vez de wildcard."
  type        = list(string)

  validation {
    condition     = length(var.resources) > 0
    error_message = "resources deve conter ao menos um item."
  }
}

variable "allow_wildcard_actions" {
  description = "Quando true, permite explicitamente que 'actions' contenha o wildcard total '*'. Use com cautela."
  type        = bool
  default     = false
}

variable "allow_wildcard_resources" {
  description = "Quando true, permite explicitamente que 'resources' contenha o wildcard total '*'. Use com cautela."
  type        = bool
  default     = false
}

variable "conditions" {
  description = "Lista opcional de condicoes IAM aplicadas a statement (test, variable, values)."
  type = list(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  default = []
}

variable "tags" {
  description = "Tags aplicadas a IAM Policy."
  type        = map(string)
  default     = {}
}
