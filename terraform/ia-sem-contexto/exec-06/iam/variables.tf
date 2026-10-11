variable "aws_region" {
  type        = string
  description = "Regiao AWS usada pelo provider. IAM e um servico global, mas o provider exige uma regiao valida."
  default     = "us-east-1"
}

variable "role_name" {
  type        = string
  description = "Nome da IAM Role a ser criada."
}

variable "role_description" {
  type        = string
  description = "Descricao da IAM Role."
  default     = "Role gerenciada via Terraform com permissoes escopadas."
}

variable "policy_name" {
  type        = string
  description = "Nome da IAM Policy a ser criada e anexada a role."
}

variable "policy_description" {
  type        = string
  description = "Descricao da IAM Policy."
  default     = "Policy gerenciada via Terraform com permissoes escopadas."
}

variable "trusted_principal_arns" {
  type        = list(string)
  description = "ARNs de principals (conta root, usuario ou role) autorizados a assumir esta role. Nao pode conter curinga."

  validation {
    condition     = length(var.trusted_principal_arns) > 0 && !contains(var.trusted_principal_arns, "*")
    error_message = "trusted_principal_arns deve conter ao menos um ARN valido e nao pode conter \"*\"."
  }

  validation {
    condition = alltrue([
      for arn in var.trusted_principal_arns : can(regex("^arn:aws:iam::\\d{12}:(root|user/.+|role/.+)$", arn))
    ])
    error_message = "Cada item de trusted_principal_arns deve ser um ARN IAM valido (conta root, user ou role), sem curinga."
  }
}

variable "external_id" {
  type        = string
  description = "ExternalId opcional exigido na trust policy, usado para mitigar o problema do 'confused deputy' em cenarios cross-account."
  default     = null
}

variable "allowed_actions" {
  type        = list(string)
  description = "Actions IAM permitidas na policy anexada a role. Nao pode conter o curinga total \"*\"."
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.allowed_actions) > 0 && !contains(var.allowed_actions, "*")
    error_message = "allowed_actions nao pode ser vazio nem conter o curinga total \"*\"."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "ARNs dos recursos aos quais allowed_actions se aplicam."

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um ARN de recurso."
  }
}

variable "allow_wildcard_resources" {
  type        = bool
  description = "Permite explicitamente o uso de \"*\" em allowed_resources. Mantenha false para evitar permissoes amplas por padrao."
  default     = false
}

variable "max_session_duration" {
  type        = number
  description = "Duracao maxima da sessao (em segundos) para credenciais temporarias obtidas ao assumir a role."
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "permissions_boundary_arn" {
  type        = string
  description = "ARN opcional de uma policy de permissions boundary aplicada a role, como camada adicional de controle."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas a IAM Role e a IAM Policy."
  default     = {}
}
