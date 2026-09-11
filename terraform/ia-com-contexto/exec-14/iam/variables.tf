variable "environment" {
  description = "Ambiente alvo (dev, hml, prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um de: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema/aplicação (minúsculas, números e hífens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS onde o provider será configurado (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "region deve seguir o padrão de regiões AWS (ex.: us-east-1)."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas ao recurso (as tags obrigatórias têm precedência)."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da policy (segmento final do nome, minúsculas/números/hífens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name)) && length(var.policy_name) > 0
    error_message = "policy_name deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "policy_description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "IAM policy gerenciada por Terraform seguindo o princípio do menor privilégio."
}

variable "policy_path" {
  description = "Caminho (path) da IAM Policy. Deve iniciar e terminar com '/'."
  type        = string
  default     = "/"

  validation {
    condition     = startswith(var.policy_path, "/") && endswith(var.policy_path, "/")
    error_message = "policy_path deve iniciar e terminar com '/'."
  }
}

variable "allowed_actions" {
  description = "Lista de ações explicitamente permitidas pela policy (ex.: [\"s3:GetObject\"])."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0 && alltrue([for a in var.allowed_actions : length(trim(a)) > 0])
    error_message = "allowed_actions deve conter ao menos uma ação não vazia."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos explicitamente permitidos (ex.: [\"arn:aws:s3:::example/*\"])."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0 && alltrue([for r in var.allowed_resources : length(trim(r)) > 0])
    error_message = "allowed_resources deve conter ao menos um ARN de recurso não vazio."
  }
}
