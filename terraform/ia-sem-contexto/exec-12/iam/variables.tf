variable "region" {
  type        = string
  description = "Região AWS onde os recursos IAM serão avaliados/criados (IAM é global, mas o provider exige uma região)."
  default     = "us-east-1"
}

variable "role_name" {
  type        = string
  description = "Nome da IAM Role a ser criada."

  validation {
    condition     = length(var.role_name) > 0 && length(var.role_name) <= 64
    error_message = "role_name deve ter entre 1 e 64 caracteres."
  }
}

variable "role_path" {
  type        = string
  description = "Path da IAM Role e da IAM Policy."
  default     = "/"
}

variable "role_description" {
  type        = string
  description = "Descrição da IAM Role."
  default     = "IAM Role gerenciada via Terraform com acesso restrito por policy dedicada."
}

variable "max_session_duration" {
  type        = number
  description = "Duração máxima (em segundos) de uma sessão assumida via esta role."
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "permissions_boundary_arn" {
  type        = string
  description = "ARN opcional de uma permissions boundary a ser aplicada à role."
  default     = null
}

variable "trusted_principal_arns" {
  type        = list(string)
  description = "Lista de ARNs de principals (contas, roles ou usuários) autorizados a assumir esta role. Não é permitido usar '*'."

  validation {
    condition     = length(var.trusted_principal_arns) > 0
    error_message = "trusted_principal_arns deve conter ao menos um ARN."
  }

  validation {
    condition     = !contains(var.trusted_principal_arns, "*")
    error_message = "trusted_principal_arns não pode conter o wildcard '*'. Especifique ARNs de principals concretos."
  }
}

variable "external_id" {
  type        = string
  description = "ExternalId opcional exigido na trust policy para mitigar o problema de confused deputy em assume role entre contas."
  default     = null
}

variable "policy_name" {
  type        = string
  description = "Nome da IAM Policy a ser criada e anexada à role."

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128
    error_message = "policy_name deve ter entre 1 e 128 caracteres."
  }
}

variable "policy_description" {
  type        = string
  description = "Descrição da IAM Policy."
  default     = "IAM Policy com permissões restritas, anexada a uma role dedicada."
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de ações IAM permitidas pela policy. Não é permitido o wildcard total '*'."
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma ação."
  }

  validation {
    condition     = alltrue([for action in var.allowed_actions : action != "*"])
    error_message = "allowed_actions não pode conter o wildcard total '*'. Especifique ações concretas (ex: 's3:GetObject')."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos aos quais as ações permitidas se aplicam. Não é permitido o wildcard total '*'."
  default     = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um ARN de recurso."
  }

  validation {
    condition     = alltrue([for resource_arn in var.allowed_resources : resource_arn != "*"])
    error_message = "allowed_resources não pode conter o wildcard total '*'. Especifique ARNs concretos."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags a serem aplicadas à IAM Role e à IAM Policy."
  default     = {}
}
