variable "aws_region" {
  description = "Regiao AWS utilizada pelo provider."
  type        = string
  default     = "us-east-1"
}

variable "policy_name" {
  description = "Nome da IAM Policy."
  type        = string
  default     = "example-least-privilege-policy"
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Politica IAM gerenciada via Terraform, seguindo o principio de menor privilegio."
}

variable "policy_path" {
  description = "Path da IAM Policy dentro da conta AWS. Deve iniciar e terminar com '/'."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/.*/$|^/$", var.policy_path))
    error_message = "policy_path deve iniciar e terminar com '/'."
  }
}

variable "statements" {
  description = "Lista de statements que compoem o documento JSON da IAM Policy."
  type = list(object({
    sid       = string
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))
  default = [
    {
      sid       = "AllowExampleS3ReadAccess"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]
    }
  ]

  validation {
    condition     = length(var.statements) > 0
    error_message = "É necessário informar ao menos um statement."
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
}

variable "tags" {
  description = "Tags aplicadas a IAM Policy."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
  }
}
