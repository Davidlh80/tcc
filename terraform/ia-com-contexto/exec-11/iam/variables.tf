variable "environment" {
  description = "Ambiente de implantacao. Deve ser um dos valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser 'dev', 'hml' ou 'prd'."
  }
}

variable "system" {
  description = "Nome do sistema ou projeto ao qual o recurso pertence, usado na nomenclatura padronizada."
  type        = string

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao da AWS usada pelo provider (IAM e um servico global, mas a regiao define o endpoint utilizado)."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias definidas pela organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da IAM Policy/Role, usada como sufixo na nomenclatura padronizada (ex.: 'readonly', 's3-access')."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "O valor de policy_name nao pode ser vazio."
  }
}

variable "trusted_principal_arn" {
  description = "ARN do principal (usuario, role ou conta) autorizado a assumir a IAM Role via trust policy. Nunca pode ser '*'."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws:iam::", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM valido (ex.: arn:aws:iam::123456789012:role/nome) e nao pode ser '*'."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas na policy (ex.: [\"s3:GetObject\", \"s3:ListBucket\"]). Nao pode combinar '*' com allowed_resources contendo '*'."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma acao."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos aos quais as acoes permitidas em allowed_actions se aplicam."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }
}
