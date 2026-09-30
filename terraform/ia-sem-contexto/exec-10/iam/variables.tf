variable "aws_region" {
  description = "Regiao AWS usada pela configuracao do provider."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string

  validation {
    condition     = length(var.role_name) > 0 && length(var.role_name) <= 64
    error_message = "role_name deve ter entre 1 e 64 caracteres."
  }
}

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "Role gerenciada via Terraform com permissoes minimas necessarias."
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada e anexada a role."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128
    error_message = "policy_name deve ter entre 1 e 128 caracteres."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy gerenciada via Terraform com permissoes minimas necessarias."
}

variable "path" {
  description = "Path aplicado a IAM Role e a IAM Policy."
  type        = string
  default     = "/"
}

variable "trusted_principal_type" {
  description = "Tipo do principal confiavel na trust policy da role (AWS, Service, Federated ou CanonicalUser)."
  type        = string
  default     = "Service"

  validation {
    condition     = contains(["AWS", "Service", "Federated", "CanonicalUser"], var.trusted_principal_type)
    error_message = "trusted_principal_type deve ser um dos valores: AWS, Service, Federated, CanonicalUser."
  }
}

variable "trusted_principal_identifiers" {
  description = "Identificadores do principal confiavel (ex.: [\"ec2.amazonaws.com\"] ou ARNs de contas/roles/usuarios)."
  type        = list(string)
  default     = ["ec2.amazonaws.com"]

  validation {
    condition     = length(var.trusted_principal_identifiers) > 0
    error_message = "trusted_principal_identifiers deve conter ao menos um identificador."
  }
}

variable "assume_role_actions" {
  description = "Acoes STS permitidas na trust policy da role."
  type        = list(string)
  default     = ["sts:AssumeRole"]

  validation {
    condition     = length(var.assume_role_actions) > 0
    error_message = "assume_role_actions deve conter ao menos uma acao."
  }
}

variable "external_id" {
  description = "External ID exigido na trust policy para reduzir o risco de confused deputy em assume role entre contas. Deixe vazio para nao exigir a condicao."
  type        = string
  default     = ""
  sensitive   = true
}

variable "policy_actions" {
  description = "Acoes IAM permitidas pela policy anexada a role. O wildcard '*' nao e permitido."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.policy_actions) > 0 && alltrue([for action in var.policy_actions : action != "*"])
    error_message = "policy_actions deve conter ao menos uma acao e nao pode incluir o wildcard '*'."
  }
}

variable "policy_resources" {
  description = "ARNs dos recursos aos quais as acoes da policy se aplicam. Deve ser explicitado pelo consumidor do modulo."
  type        = list(string)

  validation {
    condition     = length(var.policy_resources) > 0
    error_message = "policy_resources deve conter ao menos um ARN de recurso."
  }
}

variable "max_session_duration" {
  description = "Duracao maxima, em segundos, de uma sessao assumida pela role."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "force_detach_policies" {
  description = "Quando true, desanexa automaticamente as policies da role antes da destruicao."
  type        = bool
  default     = true
}

variable "permissions_boundary_arn" {
  description = "ARN da permissions boundary aplicada a role. Deixe vazio para nao aplicar nenhuma boundary."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags aplicadas a IAM Role e a IAM Policy."
  type        = map(string)
  default     = {}
}
