variable "aws_region" {
  description = "Regiao AWS onde a policy sera provisionada (IAM e global, mas o provider exige uma regiao)."
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

variable "policy_path" {
  description = "Path da IAM Policy. Deve iniciar e terminar com '/'."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/.*/$|^/$", var.policy_path))
    error_message = "O path deve iniciar e terminar com '/'."
  }
}

variable "statement_sid" {
  description = "Identificador (SID) da statement da policy."
  type        = string
  default     = "Statement1"
}

variable "effect" {
  description = "Efeito da statement: Allow ou Deny."
  type        = string
  default     = "Allow"

  validation {
    condition     = contains(["Allow", "Deny"], var.effect)
    error_message = "O valor de effect deve ser 'Allow' ou 'Deny'."
  }
}

variable "actions" {
  description = "Lista de actions IAM que a policy permite ou nega. Evite wildcard total ('*') e prefira acoes explicitas no formato 'servico:Acao'."
  type        = list(string)

  validation {
    condition     = length(var.actions) > 0
    error_message = "Informe ao menos uma action."
  }

  validation {
    condition     = alltrue([for a in var.actions : can(regex("^[a-zA-Z0-9-]+:[a-zA-Z0-9*]+$", a))])
    error_message = "Cada action deve seguir o formato 'servico:Acao', por exemplo 's3:GetObject'."
  }
}

variable "resources" {
  description = "Lista de ARNs (ou padroes de ARN) aos quais a policy se aplica. Evite '*' irrestrito; prefira ARNs especificos."
  type        = list(string)

  validation {
    condition     = length(var.resources) > 0
    error_message = "Informe ao menos um resource."
  }
}

variable "conditions" {
  description = "Lista opcional de condicoes IAM (test, variable, values) aplicadas a statement, util para restringir ainda mais o escopo da policy."
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
