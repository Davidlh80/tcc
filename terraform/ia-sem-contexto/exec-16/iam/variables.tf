variable "aws_region" {
  description = "Regiao AWS onde o provider sera configurado."
  type        = string
  default     = "us-east-1"
}

variable "policy_name" {
  description = "Nome da IAM Policy."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128
    error_message = "policy_name deve ter entre 1 e 128 caracteres."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "IAM Policy gerenciada via Terraform."
}

variable "policy_path" {
  description = "Path da IAM Policy dentro do IAM."
  type        = string
  default     = "/"
}

variable "policy_effect" {
  description = "Efeito da statement da policy. Deve ser 'Allow' ou 'Deny'."
  type        = string
  default     = "Allow"

  validation {
    condition     = contains(["Allow", "Deny"], var.policy_effect)
    error_message = "policy_effect deve ser 'Allow' ou 'Deny'."
  }
}

variable "policy_actions" {
  description = "Lista explicita de IAM actions cobertas pela policy. Nao utilize wildcards amplos como '*' ou 'service:*' em ambientes produtivos."
  type        = list(string)

  validation {
    condition     = length(var.policy_actions) > 0
    error_message = "policy_actions deve conter ao menos uma action."
  }

  validation {
    condition     = !contains(var.policy_actions, "*")
    error_message = "policy_actions nao deve conter o wildcard '*' isolado."
  }
}

variable "policy_resources" {
  description = "Lista de ARNs de recursos aos quais a policy se aplica. Evite usar '*' para escopo irrestrito."
  type        = list(string)

  validation {
    condition     = length(var.policy_resources) > 0
    error_message = "policy_resources deve conter ao menos um recurso."
  }

  validation {
    condition     = !contains(var.policy_resources, "*")
    error_message = "policy_resources nao deve conter o wildcard '*' isolado; especifique ARNs concretos."
  }
}

variable "tags" {
  description = "Tags aplicadas a IAM Policy."
  type        = map(string)
  default     = {}
}
