variable "environment" {
  description = "Ambiente de implantação do recurso (dev, hml ou prd), utilizado na composição do nome padronizado e da tag Environment."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou aplicação ao qual o recurso pertence, utilizado na composição do nome padronizado."
  type        = string

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "O valor de system não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS onde os recursos relacionados a esta policy são provisionados/utilizados."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatórias da organização."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da IAM Policy, utilizada na composição do nome padronizado (<ambiente>-<sistema>-iam-<finalidade>)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "O valor de policy_name deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "policy_description" {
  description = "Descrição da finalidade da IAM Policy."
  type        = string
  default     = "IAM Policy gerenciada via Terraform."
}

variable "policy_statements" {
  description = "Lista de statements de permissão (sempre Effect = Allow) da policy. Cada statement deve informar suas próprias ações e recursos permitidos. É proibido combinar a action \"*\" com o resource \"*\" na mesma statement."
  type = list(object({
    sid       = optional(string)
    actions   = list(string)
    resources = list(string)
  }))

  validation {
    condition     = length(var.policy_statements) > 0
    error_message = "É necessário informar ao menos um statement em policy_statements."
  }

  validation {
    condition = alltrue([
      for s in var.policy_statements : length(s.actions) > 0 && length(s.resources) > 0
    ])
    error_message = "Cada statement deve conter ao menos uma action e um resource."
  }

  validation {
    condition = alltrue([
      for s in var.policy_statements : !(contains(s.actions, "*") && contains(s.resources, "*"))
    ])
    error_message = "Não é permitido combinar a action \"*\" com o resource \"*\" na mesma statement."
  }
}
