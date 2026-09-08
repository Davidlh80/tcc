variable "aws_region" {
  description = "Região AWS onde os recursos serão gerenciados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "aws_region deve ser um código de região válido, por exemplo: us-east-1, eu-west-1."
  }
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128 && can(regex("^[\\w+=,.@-]+$", var.policy_name))
    error_message = "policy_name é obrigatório, até 128 caracteres e pode conter apenas [A-Za-z0-9+=,.@_-]."
  }
}

variable "policy_description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "Managed IAM policy created by Terraform."

  validation {
    condition     = length(var.policy_description) <= 1000
    error_message = "policy_description deve ter no máximo 1000 caracteres."
  }
}

variable "policy_path" {
  description = "Caminho da IAM Policy (deve iniciar e terminar com '/')."
  type        = string
  default     = "/"

  validation {
    condition     = startswith(var.policy_path, "/") && endswith(var.policy_path, "/") && length(var.policy_path) <= 512
    error_message = "policy_path deve iniciar e terminar com '/' e ter até 512 caracteres."
  }
}

variable "policy_statements" {
  description = "Lista de statements para a IAM Policy. Cada statement deve conter effect, actions e resources."
  type = list(object({
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))

  default = [
    {
      effect    = "Allow"
      actions   = ["iam:GetAccountSummary", "ec2:DescribeRegions"]
      resources = ["*"]
    }
  ]

  validation {
    condition = length(var.policy_statements) > 0
    error_message = "policy_statements deve conter ao menos um statement."
  }

  validation {
    condition = alltrue([for s in var.policy_statements : contains(["Allow", "Deny"], s.effect)])
    error_message = "Cada statement em policy_statements deve ter effect igual a 'Allow' ou 'Deny'."
  }

  validation {
    condition = alltrue([for s in var.policy_statements : length(s.actions) > 0])
    error_message = "Cada statement em policy_statements deve definir pelo menos uma action."
  }

  validation {
    condition = alltrue([for s in var.policy_statements : length(s.resources) > 0])
    error_message = "Cada statement em policy_statements deve definir pelo menos um resource."
  }
}

variable "tags" {
  description = "Tags a serem aplicadas na IAM Policy."
  type        = map(string)
  default = {
    ManagedBy    = "Terraform"
    IaC          = "true"
    Environment  = "dev"
  }
}
