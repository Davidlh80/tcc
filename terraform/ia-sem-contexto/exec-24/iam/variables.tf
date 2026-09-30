variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string
  default     = "app-execution-role"
}

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "Role de execucao com permissoes minimas definidas via Terraform."
}

variable "policy_name" {
  description = "Nome da IAM Policy gerenciada a ser criada e anexada a role."
  type        = string
  default     = "app-execution-policy"
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy com permissoes minimas necessarias para a role associada."
}

variable "path" {
  description = "Path da IAM Role e da IAM Policy."
  type        = string
  default     = "/"
}

variable "trusted_principal_type" {
  description = "Tipo do principal de confianca no trust policy (Service ou AWS)."
  type        = string
  default     = "Service"

  validation {
    condition     = contains(["Service", "AWS"], var.trusted_principal_type)
    error_message = "trusted_principal_type deve ser \"Service\" ou \"AWS\"."
  }
}

variable "trusted_principal_identifiers" {
  description = "Lista de identificadores do principal de confianca (ex: [\"ec2.amazonaws.com\"] para Service, ou [\"arn:aws:iam::123456789012:root\"] para AWS)."
  type        = list(string)

  validation {
    condition     = length(var.trusted_principal_identifiers) > 0
    error_message = "trusted_principal_identifiers deve conter ao menos um identificador."
  }
}

variable "external_id" {
  description = "External ID exigido no assume role, usado em cenarios de confianca entre contas. Deixe null para nao exigir."
  type        = string
  default     = null
}

variable "require_mfa" {
  description = "Se true, exige MFA presente na sessao para assumir a role (aplicavel principalmente quando o principal e do tipo AWS)."
  type        = bool
  default     = false
}

variable "max_session_duration" {
  description = "Duracao maxima, em segundos, da sessao assumida da role."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "permissions_boundary_arn" {
  description = "ARN opcional de uma permissions boundary a ser aplicada na role."
  type        = string
  default     = null
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas na policy anexada a role. Evite wildcards amplos (ex: \"*\")."
  type        = list(string)
  default = [
    "logs:CreateLogGroup",
    "logs:CreateLogStream",
    "logs:PutLogEvents",
  ]
}

variable "allowed_resource_arns" {
  description = "Lista de ARNs de recursos aos quais as allowed_actions se aplicam. Nao deve conter \"*\" em ambientes de producao."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resource_arns) > 0
    error_message = "allowed_resource_arns deve conter ao menos um ARN de recurso."
  }
}

variable "denied_actions" {
  description = "Lista opcional de acoes explicitamente negadas (Deny) sobre todos os recursos, como camada extra de protecao."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags adicionais aplicadas a role e a policy."
  type        = map(string)
  default     = {}
}
