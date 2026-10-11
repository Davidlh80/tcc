variable "aws_region" {
  description = "Região AWS onde os recursos IAM serão avaliados/criados."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string
  default     = "example-application-role"
}

variable "role_path" {
  description = "Path da IAM Role e da IAM Policy."
  type        = string
  default     = "/"
}

variable "role_description" {
  description = "Descrição da IAM Role."
  type        = string
  default     = "Role de aplicacao com permissoes restritas, criada via Terraform."
}

variable "max_session_duration" {
  description = "Duração máxima (em segundos) da sessão assumida via sts:AssumeRole. Deve estar entre 3600 (1h) e 43200 (12h)."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "trusted_principal_arn" {
  description = "ARN do principal (conta, role ou usuario) autorizado a assumir esta role. Nao pode ser \"*\" nem permitir qualquer conta."
  type        = string

  validation {
    condition = (
      var.trusted_principal_arn != "*" &&
      can(regex("^arn:aws:iam::[0-9]{12}:(root|user/.+|role/.+)$", var.trusted_principal_arn))
    )
    error_message = "trusted_principal_arn deve ser um ARN IAM valido e especifico (conta root, user ou role), nunca \"*\"."
  }
}

variable "require_external_id" {
  description = "Se true, exige ExternalId na condicao da trust policy (recomendado para acesso cross-account de terceiros)."
  type        = bool
  default     = false
}

variable "external_id" {
  description = "Valor de ExternalId exigido na trust policy quando require_external_id for true. Nao utilize valores sensiveis reais em codigo versionado."
  type        = string
  default     = ""
  sensitive   = true
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada e anexada a role."
  type        = string
  default     = "example-application-policy"
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy com permissoes minimas necessarias, criada via Terraform."
}

variable "policy_actions" {
  description = "Lista de acoes IAM permitidas pela policy. Evite acoes administrativas amplas (ex.: \"*\", \"iam:*\")."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition = alltrue([
      for action in var.policy_actions : action != "*" && action != "iam:*" && action != "*:*"
    ])
    error_message = "policy_actions nao pode conter \"*\", \"iam:*\" ou \"*:*\". Especifique acoes granularmente."
  }
}

variable "policy_resources" {
  description = "Lista de ARNs de recursos aos quais as acoes da policy se aplicam. Evite usar \"*\" quando possivel."
  type        = list(string)
  default     = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]

  validation {
    condition     = alltrue([for resource_arn in var.policy_resources : resource_arn != "*"])
    error_message = "policy_resources nao deve conter \"*\" generico. Especifique ARNs de recursos."
  }
}

variable "tags" {
  description = "Tags aplicadas a role e a policy."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
  }
}
