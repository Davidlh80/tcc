variable "aws_region" {
  description = "Regiao AWS onde os recursos serao gerenciados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "Informe uma regiao valida, por exemplo: us-east-1, us-west-2, eu-central-1."
  }
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada."
  type        = string
  default     = "example-iam-policy"

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128
    error_message = "policy_name deve ter entre 1 e 128 caracteres."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Custom IAM policy gerada via Terraform."
}

variable "policy_path" {
  description = "Caminho (path) da IAM Policy. Deve comecar e terminar com '/'."
  type        = string
  default     = "/"

  validation {
    condition     = startswith(var.policy_path, "/") && endswith(var.policy_path, "/")
    error_message = "policy_path deve comecar e terminar com '/'. Exemplo: /, /custom/."
  }
}

variable "effect" {
  description = "Efeito da declaracao da policy quando policy_json nao for fornecido. Valores aceitos: Allow ou Deny."
  type        = string
  default     = "Allow"

  validation {
    condition     = contains(["Allow", "Deny"], var.effect)
    error_message = "effect deve ser 'Allow' ou 'Deny'."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes IAM para a declaracao gerada quando policy_json nao for fornecido."
  type        = list(string)
  default     = ["s3:ListAllMyBuckets"]

  validation {
    condition     = var.policy_json != null || length(var.allowed_actions) > 0
    error_message = "allowed_actions deve ser informado quando policy_json for nulo."
  }
}

variable "resources" {
  description = "Lista de ARNs de recursos aos quais a declaracao se aplica quando policy_json nao for fornecido."
  type        = list(string)
  default     = ["*"]

  validation {
    condition     = var.policy_json != null || length(var.resources) > 0
    error_message = "resources deve ser informado quando policy_json for nulo."
  }
}

variable "policy_json" {
  description = "JSON bruto de uma IAM Policy. Quando fornecido, substitui a gerada por allowed_actions/resources."
  type        = string
  default     = null

  validation {
    condition     = var.policy_json == null || can(jsondecode(var.policy_json))
    error_message = "policy_json deve ser um JSON valido."
  }
}
