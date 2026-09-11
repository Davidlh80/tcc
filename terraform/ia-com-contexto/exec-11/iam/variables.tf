variable "environment" {
  description = "Ambiente alvo. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/aplicação (minúsculo, letras, números e hífens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "O system deve conter apenas caracteres [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS onde a policy será gerenciada."
  type        = string
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas ao recurso (as tags obrigatórias são sempre aplicadas e prevalecem)."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade/nome curto da policy (minúsculo, letras, números e hífens). Ex.: readonly, s3-access."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name)) && length(var.policy_name) > 0
    error_message = "O policy_name deve conter apenas caracteres [a-z0-9-] e não pode ser vazio."
  }
}

variable "allowed_actions" {
  description = "Lista de ações explícitas a serem permitidas (Effect: Allow). Ex.: [\"s3:GetObject\", \"s3:ListBucket\"]."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "A lista allowed_actions não pode ser vazia."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos a serem permitidos. Ex.: [\"arn:aws:s3:::meu-bucket\", \"arn:aws:s3:::meu-bucket/*\"]."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "A lista allowed_resources não pode ser vazia."
  }
}

variable "description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "IAM policy gerenciada via Terraform seguindo o princípio do menor privilégio."
}
