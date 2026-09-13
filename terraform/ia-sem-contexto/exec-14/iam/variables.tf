variable "aws_region" {
  description = "Regiao AWS utilizada pelo provider."
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
  default     = "Managed by Terraform"
}

variable "path" {
  description = "Path da IAM Policy no IAM."
  type        = string
  default     = "/"
}

variable "effect" {
  description = "Efeito da statement da policy (Allow ou Deny)."
  type        = string
  default     = "Allow"

  validation {
    condition     = contains(["Allow", "Deny"], var.effect)
    error_message = "effect deve ser \"Allow\" ou \"Deny\"."
  }
}

variable "actions" {
  description = "Lista de acoes IAM cobertas pela policy. Nao utilize o wildcard global \"*\"; prefira acoes explicitas seguindo o principio do menor privilegio."
  type        = list(string)

  validation {
    condition     = length(var.actions) > 0
    error_message = "actions deve conter pelo menos uma acao."
  }

  validation {
    condition     = alltrue([for a in var.actions : a != "*"])
    error_message = "actions nao deve conter o wildcard global \"*\"."
  }
}

variable "resources" {
  description = "Lista de ARNs de recursos aos quais a policy se aplica. Nao utilize \"*\" para escopo irrestrito; especifique ARNs concretos."
  type        = list(string)

  validation {
    condition     = length(var.resources) > 0
    error_message = "resources deve conter pelo menos um ARN."
  }

  validation {
    condition     = alltrue([for r in var.resources : r != "*"])
    error_message = "resources nao deve conter o wildcard global \"*\". Especifique ARNs concretos."
  }
}

variable "tags" {
  description = "Tags aplicadas a IAM Policy."
  type        = map(string)
  default     = {}
}
