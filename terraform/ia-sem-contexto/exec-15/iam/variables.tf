variable "aws_region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "policy_name" {
  description = "Nome da IAM Policy."
  type        = string
  default     = "least-privilege-policy"

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128
    error_message = "O nome da policy deve ter entre 1 e 128 caracteres."
  }
}

variable "policy_path" {
  description = "Path da IAM Policy dentro do IAM."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/.*/$|^/$", var.policy_path))
    error_message = "O path deve comecar e terminar com '/'."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy gerada seguindo o principio de menor privilegio."
}

variable "policy_actions" {
  description = "Lista de acoes IAM permitidas pela policy. Evite wildcards amplos (ex: '*')."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.policy_actions) > 0
    error_message = "Informe ao menos uma action valida."
  }

  validation {
    condition     = !contains(var.policy_actions, "*")
    error_message = "A action '*' nao e permitida; especifique acoes explicitas."
  }
}

variable "policy_resources" {
  description = "Lista de ARNs de recursos aos quais a policy se aplica. Evite '*' sempre que possivel."
  type        = list(string)
  default     = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]

  validation {
    condition     = length(var.policy_resources) > 0
    error_message = "Informe ao menos um ARN de recurso valido."
  }
}

variable "tags" {
  description = "Tags aplicadas a IAM Policy."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
  }
}
