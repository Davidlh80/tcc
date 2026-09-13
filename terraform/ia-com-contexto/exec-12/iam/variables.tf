variable "environment" {
  type        = string
  description = "Ambiente de implantacao do recurso (dev, hml ou prd)."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser dev, hml ou prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema ou projeto ao qual o recurso pertence."
  default     = "tcc"
}

variable "region" {
  type        = string
  description = "Regiao AWS onde os recursos serao provisionados."
  default     = "us-east-1"
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais mescladas as tags obrigatorias da organizacao."
  default     = {}
}

variable "policy_name" {
  type        = string
  description = "Finalidade da policy, utilizada na composicao do nome padronizado (ex.: readonly)."

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "policy_name nao pode ser vazio."
  }
}

variable "policy_description" {
  type        = string
  description = "Descricao funcional da IAM Policy."
  default     = "Policy gerenciada via Terraform seguindo o principio do menor privilegio."
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de acoes IAM permitidas na statement Allow da policy."

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter pelo menos uma acao."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos aos quais a statement Allow se aplica."

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter pelo menos um recurso."
  }
}
