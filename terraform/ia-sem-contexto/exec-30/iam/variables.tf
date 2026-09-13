variable "aws_region" {
  description = "Regiao AWS onde o provider ira operar."
  type        = string
  default     = "us-east-1"
}

variable "policy_name" {
  description = "Nome da IAM Policy. Deve ser unico dentro da conta AWS."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128 && can(regex("^[\\w+=,.@-]+$", var.policy_name))
    error_message = "policy_name deve ter entre 1 e 128 caracteres e conter apenas letras, numeros e os caracteres + = , . @ _ -."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Gerenciada via Terraform."
}

variable "path" {
  description = "Path da IAM Policy dentro do IAM."
  type        = string
  default     = "/"
}

variable "effect" {
  description = "Efeito da statement da policy: Allow ou Deny."
  type        = string
  default     = "Allow"

  validation {
    condition     = contains(["Allow", "Deny"], var.effect)
    error_message = "effect deve ser 'Allow' ou 'Deny'."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas ou negadas pela policy. Evite usar '*' em producao; prefira acoes especificas de servico (ex: s3:GetObject)."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter pelo menos uma acao."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos aos quais a policy se aplica. Evite '*' sempre que possivel; restrinja ao menor escopo necessario."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter pelo menos um recurso."
  }
}

variable "conditions" {
  description = "Lista opcional de blocos de condicao IAM (test, variable, values) para restringir ainda mais a statement."
  type = list(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  default = []
}

variable "tags" {
  description = "Tags a serem aplicadas na IAM Policy."
  type        = map(string)
  default     = {}
}
