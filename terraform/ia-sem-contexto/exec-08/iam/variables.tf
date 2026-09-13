variable "name" {
  description = "Nome da IAM Policy."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 128
    error_message = "O nome da policy deve ter entre 1 e 128 caracteres."
  }
}

variable "description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Managed by Terraform"
}

variable "path" {
  description = "Path da IAM Policy dentro do IAM."
  type        = string
  default     = "/"
}

variable "effect" {
  description = "Efeito da statement da policy: \"Allow\" ou \"Deny\"."
  type        = string
  default     = "Allow"

  validation {
    condition     = contains(["Allow", "Deny"], var.effect)
    error_message = "O valor de effect deve ser \"Allow\" ou \"Deny\"."
  }
}

variable "sid" {
  description = "Identificador opcional (Sid) da statement da policy."
  type        = string
  default     = null
}

variable "actions" {
  description = "Lista de actions IAM cobertas pela policy. Prefira actions especificas em vez de wildcard amplo (ex.: \"service:*\")."
  type        = list(string)

  validation {
    condition     = length(var.actions) > 0
    error_message = "Informe ao menos uma action em var.actions."
  }
}

variable "resources" {
  description = "Lista de ARNs de recursos aos quais a policy se aplica. Evite usar \"*\"; restrinja ao(s) recurso(s) especifico(s) sempre que possivel."
  type        = list(string)

  validation {
    condition     = length(var.resources) > 0
    error_message = "Informe ao menos um ARN em var.resources."
  }
}

variable "conditions" {
  description = "Lista opcional de condicoes IAM (test, variable, values) aplicadas a statement da policy."
  type = list(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  default = []
}

variable "tags" {
  description = "Mapa de tags aplicadas a IAM Policy."
  type        = map(string)
  default     = {}
}
