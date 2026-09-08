variable "aws_region" {
  description = "Regiao AWS onde a policy sera criada."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    message       = "Informe uma regiao valida, por exemplo: us-east-1, us-west-2, eu-west-1."
  }
}

variable "policy_name" {
  description = "Nome da IAM Policy."
  type        = string
  default     = "ec2-readonly-policy"

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]{1,128}$", var.policy_name))
    message       = "O nome da policy deve ter entre 1 e 128 caracteres e usar apenas A-Za-z0-9+=,.@_-."
  }
}

variable "description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "EC2 ReadOnly policy managed by Terraform"
}

variable "path" {
  description = "Caminho (path) da IAM Policy. Deve iniciar e terminar com barra (/)."
  type        = string
  default     = "/service-control/"

  validation {
    condition = startswith(var.path, "/") && endswith(var.path, "/")
    message   = "O path da policy deve iniciar e terminar com '/'. Ex.: /service-control/."
  }
  validation {
    condition = length(var.path) <= 512
    message   = "O path da policy deve ter no maximo 512 caracteres."
  }
}

variable "tags" {
  description = "Tags para a IAM Policy."
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Purpose   = "Example"
  }
}

variable "statements" {
  description = "Lista de statements da policy. Cada statement contem effect (Allow|Deny), actions, resources e (opcional) conditions."
  type = list(object({
    effect    = string
    actions   = list(string)
    resources = list(string)
    conditions = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })))
  }))
  default = [
    {
      effect    = "Allow"
      actions   = ["ec2:Describe*"]
      resources = ["*"]
      conditions = []
    }
  ]

  validation {
    condition = length(var.statements) > 0
    message   = "Pelo menos um statement deve ser fornecido."
  }

  validation {
    condition = alltrue([for s in var.statements : length(s.actions) > 0 && length(s.resources) > 0])
    message   = "Cada statement deve definir ao menos uma action e um resource."
  }

  validation {
    condition = alltrue([for s in var.statements : contains(["allow", "deny"], lower(s.effect))])
    message   = "O campo effect de cada statement deve ser Allow ou Deny."
  }
}
