variable "environment" {
  description = "Ambiente alvo (dev, hml, prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O ambiente deve ser um dos valores permitidos: dev, hml ou prd."
  }
}

variable "system" {
  description = "Identificador do sistema/produto (minúsculas, números e hifens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "O sistema deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS onde o provider irá operar (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "A região deve obedecer o padrão, por exemplo: us-east-1, eu-west-1."
  }
}

variable "policy_name" {
  description = "Finalidade da policy (usado na composição do nome conforme padrão organizacional)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name)) && length(var.policy_name) > 0
    error_message = "policy_name deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "allowed_actions" {
  description = "Lista de ações AWS IAM a serem permitidas (Effect: Allow)."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma ação."
  }

  # Segurança: proíbe combinação de Action:* e Resource:* na mesma statement
  validation {
    condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
    error_message = "Não é permitido combinar Action:\"*\" com Resource:\"*\" na mesma policy."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos aos quais as ações serão permitidas."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso (ARN)."
  }
}

variable "policy_path" {
  description = "Caminho da policy IAM (padrão '/'). Deve iniciar e terminar com '/'."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/.*/$", var.policy_path))
    error_message = "policy_path deve iniciar e terminar com '/'. Ex.: '/application/'."
  }
}

variable "policy_description" {
  description = "Descrição da policy IAM."
  type        = string
  default     = "Least-privilege IAM policy managed by Terraform following organizational controls."
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas. Não podem sobrescrever as tags obrigatórias."
  type        = map(string)
  default     = {}

  validation {
    condition     = length(setintersection(keys(var.additional_tags), ["Project", "Environment", "ManagedBy", "Owner", "CostCenter"])) == 0
    error_message = "As tags adicionais não podem sobrescrever as tags obrigatórias: Project, Environment, ManagedBy, Owner, CostCenter."
  }
}
