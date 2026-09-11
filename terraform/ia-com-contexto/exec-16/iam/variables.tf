variable "environment" {
  description = "Ambiente alvo (dev, hml, prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores permitidos: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/produto (minúsculas, números e hífens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 1
    error_message = "system deve conter apenas [a-z0-9-] e ter pelo menos 2 caracteres."
  }
}

variable "region" {
  description = "Região AWS para o provider."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "region deve estar no formato válido, por exemplo: us-east-1, sa-east-1."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas aos recursos (as tags obrigatórias são sempre aplicadas e prevalecem)."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da policy, usada na composição do nome (<environment>-<system>-iam-<policy_name>)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name)) && length(var.policy_name) > 1
    error_message = "policy_name deve conter apenas [a-z0-9-] e ter pelo menos 2 caracteres."
  }
}

variable "allowed_actions" {
  description = "Lista de ações IAM permitidas pela policy (Effect: Allow)."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions não pode ser vazio."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos permitidos pela policy (Effect: Allow)."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources não pode ser vazio."
  }
}

variable "description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "IAM policy gerenciada por Terraform seguindo princípio do menor privilégio."
}

# Controles de segurança adicionais
# - Proibir statement com Action: \"*\" e Resource: \"*\" simultaneamente.
# - Não replicar efeito de políticas administrativas gerenciadas.
validation {
  condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
  error_message = "Configuração insegura: não é permitido combinar Action \"*\" com Resource \"*\" na mesma policy."
}
