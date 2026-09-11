variable "environment" {
  description = "Ambiente onde o recurso sera criado. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema/aplicacao (minusculo, numeros e hifens)."
  type        = string

  validation {
    condition     = length(var.system) > 0 && can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.system))
    error_message = "system deve conter apenas letras minusculas, numeros e hifens (ex.: tcc)."
  }
}

variable "region" {
  description = "Regiao AWS a ser utilizada pelo provider."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "region deve corresponder a um identificador valido (ex.: us-east-1, sa-east-1)."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas ao recurso (chaves reservadas serao ignoradas: Project, Environment, ManagedBy, Owner, CostCenter)."
  type        = map(string)
  default     = {}

  validation {
    condition = length([
      for k in keys(var.additional_tags) :
      k if !(k == "Project" || k == "Environment" || k == "ManagedBy" || k == "Owner" || k == "CostCenter")
    ]) == length(keys(var.additional_tags))
    error_message = "As chaves Project, Environment, ManagedBy, Owner e CostCenter sao reservadas e nao devem ser informadas em additional_tags."
  }
}

variable "policy_name" {
  description = "Finalidade/nome curto da policy (minusculo, numeros e hifens). Sera usado na composicao <environment>-<system>-iam-<policy_name>."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0 && can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.policy_name))
    error_message = "policy_name deve conter apenas letras minusculas, numeros e hifens (ex.: readonly)."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "IAM policy gerenciada pelo Terraform com permissoes explicitamente definidas por variaveis."
}

variable "path" {
  description = "Caminho (path) da IAM Policy."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/.*/?$|^/$", var.path))
    error_message = "path deve iniciar e terminar com '/', por exemplo: '/' ou '/application/'."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes que serao permitidas (Effect: Allow). Pode incluir curingas por servico (ex.: s3:List*), mas evite privilegios excessivos."
  type        = set(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions nao pode ser vazio."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos que serao permitidos (Effect: Allow). Pode incluir '*', desde que allowed_actions nao seja '*'."
  type        = set(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources nao pode ser vazio."
  }
}

# Controles de seguranca especificos para IAM
# 1) Proibir combinacao Action='*' e Resource='*' na mesma statement.
# 2) Restringir Effect Allow apenas aos valores informados.
locals {
  has_action_all   = contains(tolist(var.allowed_actions), "*")
  has_resource_all = contains(tolist(var.allowed_resources), "*")
}

variable "guardrail_no_action_all_with_resource_all" {
  description = "Guardrail interno para validar que nao haja combinacao Action='*' e Resource='*'. Nao modifique."
  type        = bool
  default     = true

  validation {
    condition     = var.guardrail_no_action_all_with_resource_all && !(local.has_action_all && local.has_resource_all)
    error_message = "Combinacao proibida: nao e permitido usar Action='*' juntamente com Resource='*' na mesma policy."
  }
}
