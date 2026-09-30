variable "environment" {
  type        = string
  description = "Ambiente de implantação do recurso."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema ou aplicação ao qual o recurso pertence."

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system não pode ser vazio."
  }
}

variable "region" {
  type        = string
  description = "Região AWS onde os recursos serão criados."
  default     = "us-east-1"
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais a serem mescladas às tags obrigatórias da organização."
  default     = {}
}

variable "policy_name" {
  type        = string
  description = "Finalidade/identificador da IAM Policy e da IAM Role associada, usado na composição do nome padronizado (<ambiente>-<sistema>-<recurso>-<finalidade>)."

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "O valor de policy_name deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "trusted_principal_arns" {
  type        = list(string)
  description = "Lista de ARNs de principals AWS autorizados a assumir a IAM Role (trust policy). Não é permitido o valor \"*\"."

  validation {
    condition     = length(var.trusted_principal_arns) > 0
    error_message = "trusted_principal_arns deve conter ao menos um ARN de principal."
  }

  validation {
    condition     = alltrue([for p in var.trusted_principal_arns : p != "*"])
    error_message = "trusted_principal_arns não pode conter o valor \"*\" (Principal irrestrito não é permitido)."
  }
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de ações IAM permitidas (Effect: Allow) na policy gerada."

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma ação IAM."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos permitidos (Effect: Allow) na policy gerada."

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }

  validation {
    condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
    error_message = "Não é permitido combinar Action: \"*\" com Resource: \"*\" na mesma statement."
  }
}
