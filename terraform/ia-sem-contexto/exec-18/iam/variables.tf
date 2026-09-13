variable "aws_region" {
  description = "Regiao AWS utilizada pelo provider."
  type        = string
  default     = "us-east-1"
}

variable "policy_name" {
  description = "Nome da IAM Policy."
  type        = string

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,128}$", var.policy_name))
    error_message = "O nome da policy deve ter entre 1 e 128 caracteres validos para IAM (letras, numeros e os simbolos + = , . @ _ -)."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Gerenciada via Terraform."
}

variable "path" {
  description = "Path da IAM Policy dentro da conta AWS. Deve iniciar e terminar com '/'."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/.*/$|^/$", var.path))
    error_message = "O path deve iniciar e terminar com '/'."
  }
}

variable "statements" {
  description = "Lista de statements da policy. Defina explicitamente as actions e resources permitidos; evite wildcards (*) sempre que possivel para manter o menor privilegio possivel."
  type = list(object({
    sid       = string
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))

  validation {
    condition     = alltrue([for s in var.statements : contains(["Allow", "Deny"], s.effect)])
    error_message = "O campo 'effect' de cada statement deve ser 'Allow' ou 'Deny'."
  }

  validation {
    condition     = alltrue([for s in var.statements : length(s.actions) > 0])
    error_message = "Cada statement deve conter ao menos uma action."
  }

  validation {
    condition     = alltrue([for s in var.statements : length(s.resources) > 0])
    error_message = "Cada statement deve conter ao menos um resource."
  }
}

variable "tags" {
  description = "Tags aplicadas a IAM Policy."
  type        = map(string)
  default     = {}
}
