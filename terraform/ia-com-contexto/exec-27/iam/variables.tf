variable "environment" {
  description = "Ambiente de implantação (dev, hml, prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/produto (minúsculo, hífens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS para o provider."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "region deve estar no formato de região AWS, por exemplo: us-east-1, sa-east-1."
  }
}

variable "additional_tags" {
  description = "Tags adicionais (serão mescladas; tags obrigatórias prevalecem em caso de conflito)."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da policy (usado na composição do nome <environment>-<system>-iam-<policy_name>)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name)) && length(var.policy_name) > 0 && length(var.policy_name) <= 64
    error_message = "policy_name deve conter apenas [a-z0-9-], não ser vazio e ter até 64 caracteres."
  }
}

variable "allowed_actions" {
  description = "Lista de ações explícitas a serem permitidas (ex.: [\"s3:GetObject\", \"s3:ListBucket\"])."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0 && length([for a in var.allowed_actions : a if trim(a) == ""]) == 0
    error_message = "allowed_actions não pode ser vazio e não pode conter strings vazias."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos explicitamente permitidos (ex.: [\"arn:aws:s3:::bucket\", \"arn:aws:s3:::bucket/*\"])."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0 && length([for r in var.allowed_resources : r if trim(r) == ""]) == 0
    error_message = "allowed_resources não pode ser vazio e não pode conter strings vazias."
  }
}

variable "policy_description" {
  description = "Descrição da policy IAM."
  type        = string
  default     = "IAM policy gerenciada pelo Terraform, seguindo princípio do menor privilégio conforme contexto organizacional."
}

variable "policy_path" {
  description = "Caminho da policy IAM (deve iniciar e terminar com '/')."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/.*/?$", var.policy_path))
    error_message = "policy_path deve iniciar com '/' e, preferencialmente, terminar com '/'."
  }
}
