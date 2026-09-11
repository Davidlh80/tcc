variable "environment" {
  description = "Ambiente alvo. Deve ser um dos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos: dev, hml ou prd."
  }
}

variable "system" {
  description = "Nome do sistema (ex.: tcc). Use letras minúsculas, números e hífens."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "O valor de system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS onde os recursos serão gerenciados (ex.: us-east-1)."
  type        = string

  validation {
    condition     = length(var.region) > 0
    error_message = "A região não pode ser vazia."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas ao recurso."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da policy (ex.: readonly). Este valor compõe o nome final conforme <environment>-<system>-iam-<policy_name>."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name)) && length(var.policy_name) > 0
    error_message = "O valor de policy_name deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "allowed_actions" {
  description = "Lista de ações explícitas a serem permitidas (princípio do menor privilégio)."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "A lista allowed_actions deve conter ao menos uma ação."
  }

  validation {
    condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
    error_message = "É proibido combinar Action \"*\" com Resource \"*\" na mesma policy."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos aos quais as ações serão permitidas. Use \"*\" somente quando justificável e nunca em conjunto com Action \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "A lista allowed_resources deve conter ao menos um recurso."
  }
}

variable "description" {
  description = "Descrição da policy IAM."
  type        = string
  default     = "IAM policy managed by Terraform."
}
