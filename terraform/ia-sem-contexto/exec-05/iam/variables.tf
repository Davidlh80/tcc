variable "region" {
  description = "Regiao AWS onde o provider ira operar."
  type        = string
  default     = "us-east-1"
}

variable "policy_name" {
  description = "Nome da IAM Policy. Deve conter apenas caracteres permitidos pela AWS (alfanumericos e + = , . @ _ -) e ate 128 caracteres."
  type        = string

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,128}$", var.policy_name))
    error_message = "policy_name deve ter entre 1 e 128 caracteres validos para nomes de IAM Policy (letras, numeros e os simbolos + = , . @ _ -)."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Gerenciada via Terraform."
}

variable "policy_path" {
  description = "Path da IAM Policy. Deve iniciar e terminar com '/'."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/.*/$", var.policy_path))
    error_message = "policy_path deve iniciar e terminar com '/'."
  }
}

variable "effect" {
  description = "Efeito da statement da policy: Allow ou Deny."
  type        = string
  default     = "Allow"

  validation {
    condition     = contains(["Allow", "Deny"], var.effect)
    error_message = "effect deve ser \"Allow\" ou \"Deny\"."
  }
}

variable "actions" {
  description = "Lista de acoes IAM permitidas/negadas pela policy (ex.: [\"s3:GetObject\", \"s3:PutObject\"])."
  type        = list(string)

  validation {
    condition     = length(var.actions) > 0
    error_message = "actions deve conter pelo menos um elemento."
  }
}

variable "resources" {
  description = "Lista de ARNs de recursos aos quais a policy se aplica. Evite \"*\" salvo necessidade explicita (ver allow_wildcard_resources)."
  type        = list(string)

  validation {
    condition     = length(var.resources) > 0
    error_message = "resources deve conter pelo menos um elemento."
  }
}

variable "allow_wildcard_actions" {
  description = "Quando true, permite que actions contenha o valor curinga \"*\" (todas as acoes). Padrao false por seguranca."
  type        = bool
  default     = false
}

variable "allow_wildcard_resources" {
  description = "Quando true, permite que resources contenha o valor curinga \"*\" (todos os recursos). Padrao false por seguranca."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags a serem aplicadas a IAM Policy."
  type        = map(string)
  default     = {}
}
