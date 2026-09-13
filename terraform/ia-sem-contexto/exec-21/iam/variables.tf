variable "policy_name" {
  type        = string
  description = "Nome da IAM Policy. Deve ser unico dentro da conta AWS."

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128 && can(regex("^[\\w+=,.@-]+$", var.policy_name))
    error_message = "policy_name deve ter entre 1 e 128 caracteres e conter apenas letras, numeros ou os simbolos + = , . @ -."
  }
}

variable "description" {
  type        = string
  description = "Descricao da IAM Policy."
  default     = "Gerenciado via Terraform."

  validation {
    condition     = length(var.description) <= 1000
    error_message = "description deve ter no maximo 1000 caracteres."
  }
}

variable "path" {
  type        = string
  description = "Path da IAM Policy (deve iniciar e terminar com '/')."
  default     = "/"

  validation {
    condition     = var.path == "/" || can(regex("^/.+/$", var.path))
    error_message = "path deve iniciar e terminar com '/', por exemplo '/' ou '/times/dados/'."
  }
}

variable "sid" {
  type        = string
  description = "Identificador (Sid) da statement principal da policy."
  default     = "PolicyStatement"

  validation {
    condition     = can(regex("^[A-Za-z0-9]*$", var.sid))
    error_message = "sid deve conter apenas caracteres alfanumericos."
  }
}

variable "effect" {
  type        = string
  description = "Efeito da statement: Allow ou Deny."
  default     = "Allow"

  validation {
    condition     = contains(["Allow", "Deny"], var.effect)
    error_message = "effect deve ser 'Allow' ou 'Deny'."
  }
}

variable "actions" {
  type        = list(string)
  description = "Lista de actions IAM permitidas/negadas pela policy. Evite usar '*' em ambientes produtivos."

  validation {
    condition     = length(var.actions) > 0
    error_message = "actions deve conter ao menos uma action IAM."
  }
}

variable "resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos aos quais a policy se aplica. Prefira ARNs especificos em vez de '*'."

  validation {
    condition     = length(var.resources) > 0
    error_message = "resources deve conter ao menos um ARN."
  }
}

variable "conditions" {
  type = list(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  description = "Lista opcional de condicoes IAM (test/variable/values) aplicadas a statement."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas a IAM Policy."
  default     = {}
}
