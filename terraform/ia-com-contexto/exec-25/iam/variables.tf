variable "environment" {
  description = "Ambiente alvo. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml ou prd."
  }
}

variable "system" {
  description = "Identificador do sistema/produto (minúsculo, números e hífen)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system))
    error_message = "system deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "region" {
  description = "Região AWS na qual os recursos serão gerenciados (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d+$", var.region))
    error_message = "region deve estar no formato válido (ex.: us-east-1)."
  }
}

variable "additional_tags" {
  description = "Tags adicionais (serão mescladas às tags obrigatórias)."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade/nome lógico da policy (parte final do padrão de nomenclatura)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "policy_name deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "allowed_actions" {
  description = "Ações explícitas permitidas pela policy (ex.: [\"s3:GetObject\", \"s3:ListBucket\"]). Evita-se replicar privilégios administrativos."
  type        = set(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions não pode ser vazio."
  }

  validation {
    condition = alltrue([
      for a in var.allowed_actions :
      a == "*" || length(regexall("^[a-z0-9-]+:[A-Za-z0-9*]+$", a)) > 0
    ])
    error_message = "Cada ação em allowed_actions deve ser '*' ou no formato 'servico:acao' (ex.: s3:GetObject, ec2:*)."
  }
}

variable "allowed_resources" {
  description = "Recursos explícitos permitidos pela policy (ex.: ARNs)."
  type        = set(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources não pode ser vazio."
  }

  validation {
    condition = alltrue([
      for r in var.allowed_resources :
      r == "*" || can(regex("^arn:", r))
    ])
    error_message = "Cada recurso em allowed_resources deve ser '*' ou um ARN válido."
  }
}

variable "description" {
  description = "Descrição opcional da IAM Policy."
  type        = string
  default     = null
}

# Controle de segurança: proíbe statement que combine Action '*' com Resource '*'
# Implementado via validação de variáveis.
variable "_guard_no_star_star" {
  description = "Guard rail interno para bloquear combinações Action '*' e Resource '*'. Não configurar."
  type        = bool
  default     = true

  validation {
    condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
    error_message = "Combinação proibida: Action '*' com Resource '*'. Ajuste allowed_actions e/ou allowed_resources."
  }
}
