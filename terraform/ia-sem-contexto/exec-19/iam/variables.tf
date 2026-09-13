variable "aws_region" {
  description = "Regiao AWS onde os recursos serao avaliados/criados."
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "Nome da IAM Policy. Deve seguir o padrao aceito pela AWS (ate 128 caracteres, apenas letras, numeros e os simbolos + = , . @ -)."
  type        = string

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,128}$", var.name))
    error_message = "O nome da policy deve ter entre 1 e 128 caracteres validos (letras, numeros, + = , . @ -)."
  }
}

variable "description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Politica de IAM gerenciada via Terraform."
}

variable "path" {
  description = "Path da IAM Policy dentro da conta AWS. Deve iniciar e terminar com '/'."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/([\\w+=,.@-]+/)*$", var.path))
    error_message = "O path deve iniciar e terminar com '/' (ex: \"/\" ou \"/apps/time-a/\")."
  }
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas na IAM Policy."
  type        = map(string)
  default     = {}
}

variable "statements" {
  description = "Lista de statements que compoem o documento da IAM Policy. Nao permite uso de wildcard '*' em actions ou resources."
  type = list(object({
    sid       = optional(string)
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))

  default = [
    {
      sid       = "DefaultReadOnlyS3Access"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = [
        "arn:aws:s3:::example-bucket",
        "arn:aws:s3:::example-bucket/*"
      ]
    }
  ]

  validation {
    condition     = alltrue([for s in var.statements : contains(["Allow", "Deny"], s.effect)])
    error_message = "O campo 'effect' de cada statement deve ser \"Allow\" ou \"Deny\"."
  }

  validation {
    condition     = alltrue([for s in var.statements : !contains(s.actions, "*")])
    error_message = "Wildcard \"*\" em 'actions' nao e permitido; especifique as acoes explicitamente."
  }

  validation {
    condition     = alltrue([for s in var.statements : !contains(s.resources, "*")])
    error_message = "Wildcard \"*\" em 'resources' nao e permitido; especifique os ARNs explicitamente."
  }

  validation {
    condition     = length(var.statements) > 0
    error_message = "A policy deve conter ao menos um statement."
  }
}
