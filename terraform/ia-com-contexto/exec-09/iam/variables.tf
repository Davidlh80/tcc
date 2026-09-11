variable "environment" {
  description = "Ambiente alvo (dev, hml, prd)."
  type        = string
  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/projeto (minúsculas, dígitos e hifens)."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS para o provider (ex.: us-east-1)."
  type        = string
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d+$", var.region))
    error_message = "region deve corresponder ao padrão de regiões AWS (ex.: us-east-1)."
  }
}

variable "additional_tags" {
  description = "Tags adicionais para anexar aos recursos compatíveis."
  type        = map(string)
  default     = {}
  validation {
    condition     = alltrue([for v in var.additional_tags : length(trim(v)) > 0])
    error_message = "Valores em additional_tags não podem ser vazios."
  }
}

variable "policy_name" {
  description = "Finalidade/nome lógico da policy (usado como sufixo na nomenclatura)."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name)) && length(var.policy_name) > 0
    error_message = "policy_name deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "Policy gerada por Terraform para conceder permissões mínimas necessárias."
}

variable "path" {
  description = "Caminho da IAM Policy (ex.: / ou /service-role/)."
  type        = string
  default     = "/"
  validation {
    condition     = can(regex("^/(|[A-Za-z0-9+=,.@_-]+/)*$", var.path))
    error_message = "path deve iniciar com / e, se não for raiz, terminar com / utilizando apenas caracteres permitidos."
  }
}

variable "allowed_actions" {
  description = "Lista de ações explícitas que serão permitidas (ex.: [\"s3:GetObject\"])."
  type        = list(string)
  validation {
    condition     = length(var.allowed_actions) > 0 && alltrue([for a in var.allowed_actions : length(trim(a)) > 0])
    error_message = "allowed_actions deve conter ao menos uma ação não vazia."
  }
  validation {
    # Proíbe replicar efeito administrativo total: Action '*' com Resource '*' (checado em conjunto com allowed_resources).
    condition     = !(contains(var.allowed_actions, "*") && can(contains(var.allowed_resources, "*")) && contains(var.allowed_resources, "*"))
    error_message = "É proibido combinar Action '*' com Resource '*' na mesma policy."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos aos quais as ações serão aplicadas (ex.: [\"arn:aws:s3:::meu-bucket\", \"arn:aws:s3:::meu-bucket/*\"])."
  type        = list(string)
  validation {
    condition     = length(var.allowed_resources) > 0 && alltrue([for r in var.allowed_resources : length(trim(r)) > 0])
    error_message = "allowed_resources deve conter ao menos um recurso não vazio."
  }
  validation {
    # Checagem redundante para garantir bloqueio de '*'+'*' caso validations avaliem em ordens diferentes.
    condition     = !(can(contains(var.allowed_actions, "*")) && contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
    error_message = "É proibido combinar Action '*' com Resource '*' na mesma policy."
  }
}
