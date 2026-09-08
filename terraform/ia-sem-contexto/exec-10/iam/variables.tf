variable "aws_region" {
  description = "Região AWS para o provider."
  type        = string
  default     = "us-east-1"
  validation {
    condition     = can(regex("^([a-z]{2}-[a-z]+-\\d)$", var.aws_region))
    error_message = "aws_region deve estar no formato esperado, por exemplo: us-east-1, eu-west-1."
  }
}

variable "policy_name" {
  description = "Nome da IAM Managed Policy a ser criada."
  type        = string
  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,128}$", var.policy_name))
    error_message = "policy_name deve conter de 1 a 128 caracteres permitidos: letras, números e os símbolos _+=,.@-"
  }
}

variable "policy_path" {
  description = "Caminho (path) da policy. Deve começar e terminar com '/'."
  type        = string
  default     = "/"
  validation {
    condition     = var.policy_path == "/" || (startswith(var.policy_path, "/") && endswith(var.policy_path, "/"))
    error_message = "policy_path deve ser '/' ou um caminho que comece e termine com '/'."
  }
}

variable "policy_description" {
  description = "Descrição da IAM Managed Policy."
  type        = string
  default     = "Managed policy created by Terraform."
}

variable "tags" {
  description = "Tags para aplicar à policy."
  type        = map(string)
  default     = {}
}

variable "policy_json" {
  description = "JSON da policy (opcional). Se definido, tem precedência sobre policy_statements."
  type        = string
  default     = null
}

variable "policy_statements" {
  description = "Lista de declarações da policy (ignorado se policy_json for fornecido)."
  type        = list(any)
  default = [
    {
      sid        = "AllowGetCallerIdentity"
      effect     = "Allow"
      actions    = ["sts:GetCallerIdentity"]
      resources  = ["*"]
      conditions = []
    }
  ]

  validation {
    condition = alltrue([
      for s in var.policy_statements :
      contains(["Allow", "Deny"], lookup(s, "effect", "Allow"))
    ])
    error_message = "Cada declaração deve ter 'effect' igual a 'Allow' ou 'Deny'."
  }

  validation {
    condition = alltrue([
      for s in var.policy_statements :
      (can(length(lookup(s, "actions", []))) ? length(lookup(s, "actions", [])) > 0 : false)
    ])
    error_message = "Cada declaração deve conter ao menos uma ação em 'actions'."
  }

  validation {
    condition = alltrue([
      for s in var.policy_statements :
      (can(length(lookup(s, "resources", []))) ? length(lookup(s, "resources", [])) > 0 : false)
    ])
    error_message = "Cada declaração deve conter ao menos um recurso em 'resources'."
  }
}
