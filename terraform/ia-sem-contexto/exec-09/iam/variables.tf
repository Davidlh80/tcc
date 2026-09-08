variable "aws_region" {
  description = "Região AWS onde os recursos serão gerenciados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "Informe uma região AWS válida, por exemplo: us-east-1, eu-west-1."
  }
}

variable "policy_name" {
  description = "Nome da IAM Policy gerenciada."
  type        = string
  default     = "tf-readonly-policy"

  validation {
    condition     = length(var.policy_name) >= 1 && length(var.policy_name) <= 128
    error_message = "policy_name deve ter entre 1 e 128 caracteres."
  }

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]+$", var.policy_name))
    error_message = "policy_name contém caracteres inválidos. Permitidos: A-Za-z0-9+=,.@_-"
  }
}

variable "policy_path" {
  description = "Caminho da IAM Policy (deve começar e terminar com /)."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/.*/?$", var.policy_path))
    error_message = "policy_path deve começar com / e preferencialmente terminar com /. Ex: /, /service/, /managed/."
  }
}

variable "policy_description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "Managed by Terraform - Read-only baseline policy"
}

variable "actions" {
  description = "Ações a serem permitidas pela policy."
  type        = list(string)
  default = [
    "ec2:Describe*",
    "s3:ListAllMyBuckets",
    "iam:Get*",
    "iam:List*"
  ]

  validation {
    condition     = length(var.actions) > 0
    error_message = "Defina ao menos uma ação em 'actions'."
  }
}

variable "resources" {
  description = "Recursos aos quais as ações permitidas se aplicam."
  type        = list(string)
  default     = ["*"]

  validation {
    condition     = length(var.resources) > 0
    error_message = "Defina ao menos um recurso em 'resources'. Use \"*\" quando necessário."
  }
}

variable "deny_actions" {
  description = "Ações a serem explicitamente negadas. Opcional."
  type        = list(string)
  default     = []
}

variable "deny_resources" {
  description = "Recursos aos quais as ações negadas se aplicam. Usado quando deny_actions é definido."
  type        = list(string)
  default     = ["*"]

  validation {
    condition     = length(var.deny_actions) == 0 || length(var.deny_resources) > 0
    error_message = "Quando 'deny_actions' for definido, 'deny_resources' não pode estar vazio."
  }
}

variable "attach_to_users" {
  description = "Lista de usuários IAM aos quais anexar a policy."
  type        = list(string)
  default     = []
}

variable "attach_to_roles" {
  description = "Lista de roles IAM às quais anexar a policy."
  type        = list(string)
  default     = []
}

variable "attach_to_groups" {
  description = "Lista de grupos IAM aos quais anexar a policy."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags adicionais a aplicar na policy."
  type        = map(string)
  default     = {}
}
