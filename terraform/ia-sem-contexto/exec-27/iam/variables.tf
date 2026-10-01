variable "aws_region" {
  description = "Regiao AWS utilizada pelo provider."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string
  default     = "app-role"

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,64}$", var.role_name))
    error_message = "role_name deve ter entre 1 e 64 caracteres validos para nomes de IAM Role (letras, numeros e + = , . @ _ -)."
  }
}

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "IAM role gerenciada via Terraform, com principio de menor privilegio."
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada e anexada a role."
  type        = string
  default     = "app-policy"

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,128}$", var.policy_name))
    error_message = "policy_name deve ter entre 1 e 128 caracteres validos para nomes de IAM Policy (letras, numeros e + = , . @ _ -)."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Permissoes de menor privilegio gerenciadas via Terraform."
}

variable "path" {
  description = "Path aplicado tanto a IAM Role quanto a IAM Policy."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/.*/$|^/$", var.path))
    error_message = "path deve iniciar e terminar com '/', ex: '/' ou '/app/'."
  }
}

variable "trusted_principal_services" {
  description = "Lista de service principals da AWS autorizados a assumir a role (ex: ec2.amazonaws.com, lambda.amazonaws.com)."
  type        = list(string)
  default     = ["ec2.amazonaws.com"]

  validation {
    condition     = length(var.trusted_principal_services) > 0
    error_message = "trusted_principal_services nao pode ser uma lista vazia; defina ao menos um principal de confianca."
  }
}

variable "trust_condition_source_account" {
  description = "Se definido, restringe o assume role via condicao aws:SourceAccount (mitigacao de confused deputy)."
  type        = string
  default     = null
}

variable "trust_condition_source_arn" {
  description = "Se definido, restringe o assume role via condicao aws:SourceArn (mitigacao de confused deputy)."
  type        = string
  default     = null
}

variable "policy_actions" {
  description = "Lista de actions IAM permitidas pela policy. Wildcard total ('*') nao e permitido para manter o menor privilegio."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.policy_actions) > 0 && !contains(var.policy_actions, "*")
    error_message = "policy_actions nao pode ser vazio nem conter o wildcard '*'. Liste as actions especificas necessarias."
  }
}

variable "policy_resources" {
  description = "Lista de ARNs de recursos aos quais as policy_actions se aplicam. Ajuste para os recursos reais do seu ambiente."
  type        = list(string)
  default     = ["arn:aws:s3:::example-placeholder-bucket", "arn:aws:s3:::example-placeholder-bucket/*"]

  validation {
    condition     = length(var.policy_resources) > 0
    error_message = "policy_resources nao pode ser uma lista vazia."
  }
}

variable "max_session_duration" {
  description = "Duracao maxima (em segundos) da sessao assumida via esta role."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "permissions_boundary_arn" {
  description = "ARN opcional de uma IAM Policy a ser usada como permissions boundary da role."
  type        = string
  default     = null

  validation {
    condition     = var.permissions_boundary_arn == null || can(regex("^arn:aws[a-zA-Z-]*:iam::\\d{12}:policy/.+$", var.permissions_boundary_arn))
    error_message = "permissions_boundary_arn deve ser nulo ou um ARN valido de IAM Policy."
  }
}

variable "force_detach_policies" {
  description = "Se true, permite que policies sejam desanexadas automaticamente ao destruir a role."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags aplicadas a role e a policy."
  type        = map(string)
  default     = {}
}
