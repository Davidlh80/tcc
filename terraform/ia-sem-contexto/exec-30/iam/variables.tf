variable "aws_region" {
  description = "AWS region onde os recursos serao criados."
  type        = string
  default     = "us-east-1"
  validation {
    condition     = length(trim(var.aws_region)) > 0
    error_message = "aws_region nao pode ser vazio."
  }
}

variable "policy_name" {
  description = "Nome da IAM Policy gerenciada."
  type        = string
  default     = "example-managed-policy"
  validation {
    condition     = length(trim(var.policy_name)) > 0 && length(var.policy_name) <= 128
    error_message = "policy_name deve ter entre 1 e 128 caracteres."
  }
}

variable "policy_path" {
  description = "Caminho (path) da IAM Policy. Deve iniciar e terminar com '/'."
  type        = string
  default     = "/"
  validation {
    condition     = var.policy_path == "/" || (startswith(var.policy_path, "/") && endswith(var.policy_path, "/"))
    error_message = "policy_path deve ser '/' ou iniciar e terminar com '/'."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Managed policy criada via Terraform."
}

variable "policy_effect" {
  description = "Effect do statement principal da policy (Allow ou Deny)."
  type        = string
  default     = "Allow"
  validation {
    condition     = contains(["Allow", "Deny"], var.policy_effect)
    error_message = "policy_effect deve ser 'Allow' ou 'Deny'."
  }
}

variable "policy_actions" {
  description = "Lista de acoes permitidas/negadas pelo statement principal da policy."
  type        = list(string)
  default = [
    "ec2:Describe*",
    "s3:Get*",
    "s3:List*",
    "iam:Get*",
    "iam:List*",
    "logs:Describe*",
    "logs:Get*",
    "logs:List*",
    "cloudwatch:List*",
    "cloudwatch:Get*",
    "cloudtrail:LookupEvents",
    "rds:Describe*",
    "elasticloadbalancing:Describe*",
    "sts:GetCallerIdentity"
  ]
  validation {
    condition     = length(var.policy_actions) > 0 && length(compact(var.policy_actions)) == length(var.policy_actions)
    error_message = "policy_actions deve conter pelo menos uma acao e nao pode conter strings vazias."
  }
}

variable "policy_resources" {
  description = "Lista de ARNs de recursos aos quais o statement principal se aplica."
  type        = list(string)
  default     = ["*"]
  validation {
    condition     = length(var.policy_resources) > 0 && length(compact(var.policy_resources)) == length(var.policy_resources)
    error_message = "policy_resources deve conter pelo menos um recurso e nao pode conter strings vazias."
  }
}

variable "policy_conditions" {
  description = "Mapa de conditions opcionais para o statement principal. Chave arbitraria; valores com test, variable e values."
  type = map(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  default = {}
}

variable "tags" {
  description = "Tags a serem aplicadas aos recursos."
  type        = map(string)
  default     = {}
}
