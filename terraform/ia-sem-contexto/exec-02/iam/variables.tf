variable "aws_region" {
  description = "Regiao AWS utilizada pelo provider."
  type        = string
  default     = "us-east-1"
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada."
  type        = string
  default     = "app-custom-policy"

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,128}$", var.policy_name))
    error_message = "policy_name deve conter de 1 a 128 caracteres validos para nomes de IAM policy (letras, numeros e os caracteres + = , . @ _ -)."
  }
}

variable "path" {
  description = "Path da IAM Policy dentro do IAM."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/.*/$|^/$", var.path))
    error_message = "path deve iniciar e terminar com '/', por exemplo '/' ou '/app/'."
  }
}

variable "description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy gerenciada via Terraform com permissoes de menor privilegio."
}

variable "statements" {
  description = "Lista de statements da IAM Policy. Cada statement deve declarar effect, actions e resources explicitos (sem wildcard em resources)."
  type = list(object({
    sid       = string
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))

  default = [
    {
      sid    = "AllowS3ReadOnlyExampleBucket"
      effect = "Allow"
      actions = [
        "s3:GetObject",
        "s3:ListBucket",
      ]
      resources = [
        "arn:aws:s3:::example-bucket",
        "arn:aws:s3:::example-bucket/*",
      ]
    }
  ]

  validation {
    condition = alltrue([
      for s in var.statements : contains(["Allow", "Deny"], s.effect)
    ])
    error_message = "O campo effect de cada statement deve ser 'Allow' ou 'Deny'."
  }

  validation {
    condition = alltrue([
      for s in var.statements : length(s.actions) > 0 && length(s.resources) > 0
    ])
    error_message = "Cada statement deve conter ao menos uma action e um resource."
  }

  validation {
    condition = alltrue([
      for s in var.statements : !contains(s.resources, "*")
    ])
    error_message = "Uso de wildcard '*' isolado em resources nao e permitido; especifique ARNs explicitos."
  }
}

variable "tags" {
  description = "Tags aplicadas a IAM Policy."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
  }
}
