variable "aws_region" {
  description = "Regiao AWS utilizada pelo provider."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string
  default     = "app-restricted-role"
}

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "Role de aplicacao com permissoes restritas, criada via Terraform."
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada e anexada a role."
  type        = string
  default     = "app-restricted-policy"
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy com permissoes restritas, sem acoes administrativas ou wildcard amplo."
}

variable "trusted_principal_arn" {
  description = "ARN do principal (role, usuario ou conta) autorizado a assumir esta role. Nao pode ser '*'."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws[a-zA-Z-]*:iam::\\d{12}:(role|user|root)", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM valido (role, user ou root) e nao pode ser '*'."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas pela policy. Nao deve conter wildcard amplo ('*')."
  type        = list(string)
  default = [
    "logs:CreateLogGroup",
    "logs:CreateLogStream",
    "logs:PutLogEvents",
  ]

  validation {
    condition     = length(var.allowed_actions) > 0 && !contains(var.allowed_actions, "*")
    error_message = "allowed_actions nao pode estar vazia nem conter o wildcard '*'."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos sobre os quais as acoes sao permitidas. Nao deve conter wildcard amplo ('*')."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0 && !contains(var.allowed_resources, "*")
    error_message = "allowed_resources nao pode estar vazia nem conter o wildcard '*'."
  }
}

variable "max_session_duration" {
  description = "Duracao maxima (em segundos) de uma sessao assumida da role."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "tags" {
  description = "Tags aplicadas aos recursos IAM criados."
  type        = map(string)
  default     = {}
}
