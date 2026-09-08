variable "aws_region" {
  description = "Região AWS a ser utilizada pelo provider."
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Perfil AWS do arquivo de credenciais (opcional)."
  type        = string
  default     = null
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada."
  type        = string
  default     = "example-sts-getcalleridentity"

  validation {
    condition     = length(var.policy_name) >= 1 && length(var.policy_name) <= 128
    error_message = "policy_name deve ter entre 1 e 128 caracteres."
  }

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]+$", var.policy_name))
    error_message = "policy_name possui caracteres inválidos. Permitidos: letras, números, e os símbolos +=,.@_-"
  }
}

variable "policy_description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "Policy gerenciada por Terraform."

  validation {
    condition     = length(var.policy_description) <= 1000
    error_message = "policy_description deve ter até 1000 caracteres."
  }
}

variable "policy_path" {
  description = "Caminho (path) da IAM Policy. Deve começar e terminar com '/'."
  type        = string
  default     = "/"

  validation {
    condition     = var.policy_path == "/" || can(regex("^/.*/$", var.policy_path))
    error_message = "policy_path deve ser '/' ou iniciar e terminar com '/'. Ex: '/', '/app/', '/team/security/'."
  }
}

variable "tags" {
  description = "Tags a serem aplicadas à IAM Policy."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : length(trim(k)) > 0 && length(trim(v)) > 0])
    error_message = "Todas as chaves e valores de tags devem ser strings não vazias."
  }
}

variable "statements" {
  description = <<EOT
Lista de statements da policy. Cada statement suporta:
- sid (opcional): string
- effect: 'Allow' ou 'Deny'
- actions (opcional): lista de ações
- not_actions (opcional): lista de ações negadas (use alternativamente a 'actions')
- resources (opcional): lista de ARNs de recursos
- not_resources (opcional): lista de ARNs excluídos (use alternativamente a 'resources')
- conditions (opcional): lista de condições com { test, variable, values }
Pelo menos um entre actions/not_actions e um entre resources/not_resources devem ser informados por statement.
EOT
  type = list(object({
    sid           = optional(string)
    effect        = string
    actions       = optional(list(string))
    not_actions   = optional(list(string))
    resources     = optional(list(string))
    not_resources = optional(list(string))
    conditions = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })))
  }))

  # Default seguro e mínimo para permitir validação sem depender de recursos reais
  default = [
    {
      sid       = "AllowCallerIdentity"
      effect    = "Allow"
      actions   = ["sts:GetCallerIdentity"]
      resources = ["*"]
    }
  ]

  validation {
    condition     = alltrue([for s in var.statements : contains(["Allow", "Deny"], s.effect)])
    error_message = "Cada statement.effect deve ser 'Allow' ou 'Deny'."
  }

  validation {
    condition = alltrue([
      for s in var.statements :
      (try(length(s.actions), 0) > 0) || (try(length(s.not_actions), 0) > 0)
    ])
    error_message = "Cada statement deve conter 'actions' ou 'not_actions' com ao menos um item."
  }

  validation {
    condition = alltrue([
      for s in var.statements :
      (try(length(s.resources), 0) > 0) || (try(length(s.not_resources), 0) > 0)
    ])
    error_message = "Cada statement deve conter 'resources' ou 'not_resources' com ao menos um item."
  }
}
