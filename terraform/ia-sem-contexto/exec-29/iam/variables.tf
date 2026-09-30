variable "role_name" {
  type        = string
  description = "Nome da IAM Role a ser criada."
  default     = "app-role"

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,64}$", var.role_name))
    error_message = "role_name deve ter entre 1 e 64 caracteres validos para nomes de IAM Role."
  }
}

variable "role_description" {
  type        = string
  description = "Descricao da IAM Role."
  default     = "Role gerenciada via Terraform com policy dedicada anexada."
}

variable "role_path" {
  type        = string
  description = "Path da IAM Role e da IAM Policy."
  default     = "/"
}

variable "max_session_duration" {
  type        = number
  description = "Duracao maxima (em segundos) de uma sessao assumida da role."
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos, conforme limites do IAM."
  }
}

variable "permissions_boundary_arn" {
  type        = string
  description = "ARN de uma policy a ser usada como permissions boundary da role (opcional, porem recomendado)."
  default     = null
}

variable "trusted_service_principals" {
  type        = list(string)
  description = "Lista de service principals da AWS autorizados a assumir a role (ex: ec2.amazonaws.com)."
  default     = ["ec2.amazonaws.com"]
}

variable "trusted_principal_arns" {
  type        = list(string)
  description = "Lista de ARNs de contas/roles/usuarios AWS autorizados a assumir a role."
  default     = []
}

variable "external_id" {
  type        = string
  description = "External ID exigido na assume role policy, recomendado para cenarios cross-account."
  default     = null
  sensitive   = true
}

variable "policy_name" {
  type        = string
  description = "Nome da IAM Policy anexada a role."
  default     = "app-policy"

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,128}$", var.policy_name))
    error_message = "policy_name deve ter entre 1 e 128 caracteres validos para nomes de IAM Policy."
  }
}

variable "policy_description" {
  type        = string
  description = "Descricao da IAM Policy."
  default     = "Policy de privilegio minimo anexada a IAM Role dedicada."
}

variable "policy_actions" {
  type        = list(string)
  description = "Lista de actions IAM permitidas pela policy. Nao deve conter wildcard '*'."
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.policy_actions) > 0 && !contains(var.policy_actions, "*")
    error_message = "policy_actions nao pode ser vazio nem conter a action wildcard '*'."
  }
}

variable "policy_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos aos quais as actions se aplicam. Nao deve conter wildcard '*'."
  default     = ["arn:aws:s3:::example-bucket-name/*"]

  validation {
    condition     = length(var.policy_resources) > 0 && !contains(var.policy_resources, "*")
    error_message = "policy_resources nao pode ser vazio nem conter o resource wildcard '*'."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas a IAM Role e a IAM Policy."
  default     = {}
}
