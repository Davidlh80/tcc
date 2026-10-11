variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,64}$", var.role_name))
    error_message = "role_name deve ter entre 1 e 64 caracteres validos para nomes de IAM Role."
  }
}

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "Role gerenciada via Terraform com permissoes restritas."
}

variable "role_path" {
  description = "Path da IAM Role e da IAM Policy."
  type        = string
  default     = "/"
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
  description = "ARN opcional de permissions boundary aplicada a role. Deixe vazio para nao aplicar nenhuma."
  type        = string
  default     = ""
}

variable "trusted_principal_type" {
  description = "Tipo de principal da trust policy (AWS para contas/roles/usuarios, Service para servicos AWS, ou Federated)."
  type        = string
  default     = "AWS"

  validation {
    condition     = contains(["AWS", "Service", "Federated"], var.trusted_principal_type)
    error_message = "trusted_principal_type deve ser \"AWS\", \"Service\" ou \"Federated\"."
  }
}

variable "trusted_principal_arns" {
  description = "Lista de ARNs (ou service principals) autorizados a assumir a role. Nao deve conter \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.trusted_principal_arns) > 0
    error_message = "trusted_principal_arns deve conter ao menos um principal."
  }

  validation {
    condition     = !contains(var.trusted_principal_arns, "*")
    error_message = "trusted_principal_arns nao pode conter \"*\" (wildcard de principal nao e permitido)."
  }
}

variable "require_external_id" {
  description = "Se verdadeiro, exige a condicao sts:ExternalId na trust policy (recomendado para acesso cross-account de terceiros)."
  type        = bool
  default     = false
}

variable "external_id" {
  description = "Valor do ExternalId exigido na trust policy quando require_external_id = true."
  type        = string
  default     = ""
  sensitive   = true
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada."
  type        = string

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,128}$", var.policy_name))
    error_message = "policy_name deve ter entre 1 e 128 caracteres validos para nomes de IAM Policy."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy gerenciada via Terraform com permissoes restritas."
}

variable "policy_actions" {
  description = "Lista de actions permitidas pela IAM Policy. Evite wildcards amplos (ex.: \"*\" ou \"servico:*\")."
  type        = list(string)
  default = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  validation {
    condition     = length(var.policy_actions) > 0
    error_message = "policy_actions deve conter ao menos uma action."
  }

  validation {
    condition     = !contains(var.policy_actions, "*")
    error_message = "policy_actions nao pode conter o wildcard \"*\" (permissao administrativa irrestrita)."
  }

  validation {
    condition     = alltrue([for action in var.policy_actions : !endswith(action, ":*")])
    error_message = "policy_actions nao deve conter wildcards amplos de servico, como \"iam:*\" ou \"ec2:*\"."
  }
}

variable "policy_resources" {
  description = "Lista de ARNs de recursos aos quais a policy se aplica. Evite \"*\" quando possivel."
  type        = list(string)
  default = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*",
  ]

  validation {
    condition     = length(var.policy_resources) > 0
    error_message = "policy_resources deve conter ao menos um recurso."
  }
}

variable "tags" {
  description = "Tags aplicadas a IAM Role e a IAM Policy."
  type        = map(string)
  default     = {}
}
