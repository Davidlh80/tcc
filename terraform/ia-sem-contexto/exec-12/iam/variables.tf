variable "aws_region" {
  type        = string
  description = "Regiao AWS utilizada pelo provider para chamadas de API. IAM e um servico global, mas o provider AWS exige uma regiao configurada."
  default     = "us-east-1"
}

variable "name" {
  type        = string
  description = "Nome da IAM Policy."

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,128}$", var.name))
    error_message = "O nome deve ter entre 1 e 128 caracteres e conter apenas letras, numeros e os caracteres + = , . @ _ -."
  }
}

variable "path" {
  type        = string
  description = "Path da IAM Policy."
  default     = "/"

  validation {
    condition     = can(regex("^/$|^/.*/$", var.path))
    error_message = "O path deve comecar e terminar com '/'."
  }
}

variable "description" {
  type        = string
  description = "Descricao da IAM Policy."
  default     = "Gerenciado via Terraform."
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais aplicadas a IAM Policy, alem das tags padrao definidas internamente."
  default     = {}
}

variable "statements" {
  description = "Lista de statements que compoem o documento da IAM Policy. E obrigatorio declarar explicitamente as actions e resources permitidos; wildcards ('*') em actions ou resources nao sao aceitos em statements com effect = Allow, forcando a definicao de permissoes minimas necessarias."

  type = list(object({
    sid       = optional(string)
    effect    = optional(string, "Allow")
    actions   = list(string)
    resources = list(string)
    condition = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })), [])
  }))

  validation {
    condition     = length(var.statements) > 0
    error_message = "E necessario informar ao menos um statement para a IAM Policy."
  }

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

  validation {
    condition     = alltrue([for s in var.statements : s.effect != "Allow" || !contains(s.actions, "*")])
    error_message = "Wildcard '*' em actions nao e permitido para statements com effect = Allow."
  }

  validation {
    condition     = alltrue([for s in var.statements : s.effect != "Allow" || !contains(s.resources, "*")])
    error_message = "Wildcard '*' em resources nao e permitido para statements com effect = Allow."
  }
}
