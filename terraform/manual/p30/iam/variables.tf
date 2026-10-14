variable "environment" {
  description = "Ambiente usado nos nomes e nas tags dos recursos IAM."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser dev, hml ou prd."
  }
}

variable "system" {
  description = "Identificador do sistema usado nos nomes dos recursos IAM."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]*[a-z0-9])?$", var.system))
    error_message = "system deve conter somente caracteres minúsculos, números ou hífens, sem hífen inicial ou final."
  }
}

variable "region" {
  description = "Região AWS usada pelo provider."
  type        = string

  validation {
    condition     = length(trimspace(var.region)) > 0
    error_message = "region não pode ser vazia."
  }
}

variable "additional_tags" {
  description = "Tags adicionais opcionais. Tags obrigatórias não podem ser sobrescritas."
  type        = map(string)
  default     = {}
}

variable "role_name" {
  description = "Finalidade usada para formar os nomes da Role, da política e do instance profile."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.role_name)) && length("${var.environment}-${var.system}-iam-${var.role_name}") <= 64
    error_message = "role_name deve conter caracteres permitidos pelo IAM e formar um nome de Role com até 64 caracteres."
  }
}

variable "owner" {
  description = "Responsável exigido pela tag organizacional Owner."
  type        = string

  validation {
    condition     = var.owner == "devops"
    error_message = "owner deve ser devops, conforme o contexto organizacional."
  }
}

variable "required_tags" {
  description = "Tags obrigatórias de valor fixo definidas pelo padrão organizacional."
  type        = map(string)
  default = {
    Project    = "tcc-iac-ia"
    ManagedBy  = "terraform"
    CostCenter = "academic-research"
  }

  validation {
    condition     = contains(keys(var.required_tags), "Project") && contains(keys(var.required_tags), "ManagedBy") && contains(keys(var.required_tags), "CostCenter") && var.required_tags.Project == "tcc-iac-ia" && var.required_tags.ManagedBy == "terraform" && var.required_tags.CostCenter == "academic-research"
    error_message = "required_tags deve conter Project, ManagedBy e CostCenter com os valores organizacionais definidos."
  }
}

variable "trusted_principal_arn" {
  description = "Principal de serviço AWS autorizado a assumir a Role, por exemplo ec2.amazonaws.com."
  type        = string
  default     = "ec2.amazonaws.com"

  validation {
    condition     = endswith(var.trusted_principal_arn, ".amazonaws.com")
    error_message = "trusted_principal_arn deve ser um principal de serviço terminado em .amazonaws.com."
  }
}

variable "trust_source_account_id" {
  description = "ID de conta opcional para a condição aws:SourceAccount contra confused deputy."
  type        = string
  default     = null
  nullable    = true

  validation {
    condition     = var.trust_source_account_id == null || can(regex("^[0-9]{12}$", var.trust_source_account_id))
    error_message = "trust_source_account_id deve ser nulo ou conter exatamente 12 dígitos."
  }
}

variable "trust_source_arn" {
  description = "ARN opcional para a condição aws:SourceArn contra confused deputy."
  type        = string
  default     = null
  nullable    = true
}

variable "role_description" {
  description = "Descrição da Role IAM."
  type        = string

  validation {
    condition     = length(trimspace(var.role_description)) > 0
    error_message = "role_description não pode ser vazia."
  }
}

variable "max_session_duration" {
  description = "Duração máxima da sessão da Role em segundos."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200 && floor(var.max_session_duration) == var.max_session_duration
    error_message = "max_session_duration deve ser um inteiro entre 3600 e 43200."
  }
}

variable "permissions_boundary_arn" {
  description = "ARN opcional de uma permissions boundary para limitar as permissões máximas da Role."
  type        = string
  default     = null
  nullable    = true

  validation {
    condition     = var.permissions_boundary_arn == null || can(regex("^arn:[^:]+:iam::[0-9]{12}:policy/.+$", var.permissions_boundary_arn))
    error_message = "permissions_boundary_arn deve ser nulo ou um ARN IAM de policy com partição e ID de conta válidos."
  }
}

variable "path" {
  description = "Path IAM aplicado à Role, política e instance profile."
  type        = string
  default     = "/"

  validation {
    condition     = startswith(var.path, "/") && endswith(var.path, "/")
    error_message = "path deve começar e terminar com /."
  }
}

variable "s3_read_bucket_arns" {
  description = "ARNs dos buckets nos quais a Role pode listar o bucket e ler objetos."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for arn in var.s3_read_bucket_arns :
      length(trimspace(arn)) > 0 && startswith(arn, "arn:aws:s3:::") && !strcontains(arn, "*")
    ])
    error_message = "Cada ARN deve começar com arn:aws:s3::: e não pode estar vazio nem conter *."
  }
}

variable "additional_allowed_actions_by_resource" {
  description = "Permissões adicionais explicitamente limitadas por ações e recursos."
  type = map(object({
    sid       = string
    actions   = list(string)
    resources = list(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for permission in values(var.additional_allowed_actions_by_resource) :
      length(trimspace(permission.sid)) > 0 &&
      can(regex("^[A-Za-z0-9]+$", permission.sid)) &&
      length(permission.actions) > 0 &&
      length(permission.resources) > 0 &&
      alltrue([
        for action in permission.actions :
        length(trimspace(action)) > 0 &&
        lower(action) != "*" &&
        !endswith(lower(action), ":*") &&
        !startswith(lower(action), "iam:")
      ]) &&
      alltrue([for resource in permission.resources : length(trimspace(resource)) > 0 && resource != "*"])
    ])
    error_message = "Cada permissão deve ter sid, ações e recursos; ações wildcard ou iam:* e recursos '*' não são permitidos."
  }
}

variable "enable_ssm_access" {
  description = "Anexa AmazonSSMManagedInstanceCore à Role para permitir acesso administrativo via SSM."
  type        = bool
  default     = true
}

variable "create_instance_profile" {
  description = "Cria um instance profile associado à Role para workloads EC2."
  type        = bool
  default     = true
}
