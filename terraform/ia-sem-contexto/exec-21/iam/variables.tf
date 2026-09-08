variable "aws_region" {
  description = "Região AWS onde o provider irá operar."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}(-gov)?-[a-z]+-\\d$", var.aws_region))
    error_message = "A região deve ser um identificador válido, por exemplo: us-east-1, us-west-2, eu-central-1."
  }
}

variable "policy_name" {
  description = "Nome base da IAM Policy. Se use_name_prefix=true, será usado como prefixo; caso contrário, como nome exato."
  type        = string
  default     = "example-readonly"

  validation {
    condition     = can(regex("^[A-Za-z0-9_=,.@-]{1,128}$", var.policy_name))
    error_message = "policy_name deve conter apenas [A-Za-z0-9_=,.@-] e ter entre 1 e 128 caracteres."
  }
}

variable "use_name_prefix" {
  description = "Quando true, usa policy_name como prefixo (recomendado para evitar colisões). Quando false, usa como nome fixo."
  type        = bool
  default     = true
}

variable "policy_description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "Read-only access to common AWS services with secure-by-default settings."

  validation {
    condition     = length(var.policy_description) > 0 && length(var.policy_description) <= 1000
    error_message = "A descrição deve ter entre 1 e 1000 caracteres."
  }
}

variable "policy_path" {
  description = "Caminho da policy. Deve começar e terminar com '/'."
  type        = string
  default     = "/"

  validation {
    condition     = startswith(var.policy_path, "/") && endswith(var.policy_path, "/")
    error_message = "policy_path deve começar e terminar com '/'. Exemplos: '/', '/service/', '/team/app/'."
  }
}

variable "tags" {
  description = "Tags a serem aplicadas à IAM Policy."
  type        = map(string)
  default     = {}
}

variable "effect" {
  description = "Efeito da declaração base ('Allow' ou 'Deny')."
  type        = string
  default     = "Allow"

  validation {
    condition     = contains(["Allow", "Deny"], var.effect)
    error_message = "effect deve ser 'Allow' ou 'Deny'."
  }
}

variable "actions" {
  description = "Ações IAM permitidas/negadas na declaração base."
  type        = list(string)
  default = [
    "ec2:Describe*",
    "iam:GetAccountSummary",
    "iam:GetUser",
    "iam:List*",
    "s3:ListAllMyBuckets",
    "s3:GetBucketLocation",
    "cloudwatch:Get*",
    "cloudwatch:List*",
    "logs:Describe*",
    "logs:Get*",
    "logs:List*"
  ]

  validation {
    condition     = length(var.actions) > 0 && alltrue([for a in var.actions : length(trim(a)) > 0])
    error_message = "actions não pode ser vazio e não deve conter strings vazias."
  }
}

variable "resources" {
  description = "Recursos aos quais a declaração base se aplica."
  type        = list(string)
  default     = ["*"]

  validation {
    condition     = length(var.resources) > 0 && alltrue([for r in var.resources : length(trim(r)) > 0])
    error_message = "resources não pode ser vazio e não deve conter strings vazias."
  }
}

variable "base_statement_sid" {
  description = "SID da declaração base."
  type        = string
  default     = "AllowReadOnlyAccess"

  validation {
    condition     = can(regex("^[A-Za-z0-9]+[A-Za-z0-9_-]*$", var.base_statement_sid))
    error_message = "base_statement_sid deve ser alfanumérico e pode conter '-' ou '_'."
  }
}

variable "conditions" {
  description = "Condições opcionais para a declaração base."
  type = list(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  default = []
}

variable "include_base_statement" {
  description = "Quando true, inclui a declaração base. Se false, forneça additional_statements."
  type        = bool
  default     = true
}

variable "additional_statements" {
  description = "Declarações IAM adicionais (cada uma com actions e resources obrigatórios)."
  type = list(object({
    sid        = optional(string)
    effect     = optional(string, "Allow")
    actions    = list(string)
    resources  = list(string)
    conditions = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for s in var.additional_statements :
      length(s.actions) > 0 && length(s.resources) > 0 &&
      alltrue([for a in s.actions : length(trim(a)) > 0]) &&
      alltrue([for r in s.resources : length(trim(r)) > 0]) &&
      contains(["Allow", "Deny"], try(s.effect, "Allow"))
    ])
    error_message = "Cada additional_statement deve ter actions/resources não vazios e effect 'Allow' ou 'Deny'."
  }
}
