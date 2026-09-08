variable "region" {
  description = "Região AWS para o provider."
  type        = string
  default     = "us-east-1"
  validation {
    condition     = length(var.region) > 0
    error_message = "A região não pode ser vazia."
  }
}

variable "enabled" {
  description = "Controla a criação do recurso. Quando false, o recurso não é criado."
  type        = bool
  default     = true
}

variable "policy_name" {
  description = "Nome da IAM Policy (1-128 chars). Permitidos: alfanumérico e +=,.@_-"
  type        = string
  default     = "tf-managed-iam-policy"
  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]{1,128}$", var.policy_name))
    error_message = "policy_name inválido. Use 1-128 caracteres: alfanuméricos e +=,.@_-"
  }
}

variable "policy_description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "IAM policy gerenciada pelo Terraform."
}

variable "policy_path" {
  description = "Caminho da IAM Policy. Deve iniciar e terminar com '/'."
  type        = string
  default     = "/"
  validation {
    condition     = startswith(var.policy_path, "/") && endswith(var.policy_path, "/")
    error_message = "policy_path deve iniciar e terminar com '/'. Ex.: '/', '/team/'."
  }
}

variable "policy_effect" {
  description = "Efeito da declaração da policy (Allow ou Deny)."
  type        = string
  default     = "Allow"
  validation {
    condition     = contains(["Allow", "Deny"], var.policy_effect)
    error_message = "policy_effect deve ser 'Allow' ou 'Deny'."
  }
}

variable "policy_actions" {
  description = "Lista de ações IAM para a declaração da policy."
  type        = list(string)
  default     = ["sts:GetCallerIdentity"]
  validation {
    condition     = length(var.policy_actions) > 0 && alltrue([for a in var.policy_actions : length(trim(a)) > 0])
    error_message = "policy_actions deve conter ao menos uma ação não vazia."
  }
}

variable "policy_resources" {
  description = "Lista de ARNs de recursos aos quais a policy se aplica."
  type        = list(string)
  default     = ["*"]
  validation {
    condition     = length(var.policy_resources) > 0 && alltrue([for r in var.policy_resources : length(trim(r)) > 0])
    error_message = "policy_resources deve conter ao menos um recurso não vazio (use '*' para global)."
  }
}

variable "tags" {
  description = "Tags adicionais a aplicar na IAM Policy."
  type        = map(string)
  default     = {}
  validation {
    condition     = alltrue([for k, v in var.tags : length(trim(k)) > 0 && length(trim(v)) >= 0])
    error_message = "As chaves de tags não podem ser vazias."
  }
}

variable "prevent_destroy" {
  description = "Evita destruição acidental da policy. Defina como false para permitir destruição."
  type        = bool
  default     = true
}
