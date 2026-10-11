variable "aws_region" {
  type        = string
  description = "Regiao AWS onde os recursos IAM serao avaliados pelo provider."
  default     = "us-east-1"
}

variable "role_name" {
  type        = string
  description = "Nome da IAM Role a ser criada."
  default     = "app-scoped-role"
}

variable "role_path" {
  type        = string
  description = "Path da IAM Role."
  default     = "/"
}

variable "role_description" {
  type        = string
  description = "Descricao da IAM Role."
  default     = "IAM Role com assume role policy restrita e permissoes escopadas."
}

variable "max_session_duration" {
  type        = number
  description = "Duracao maxima (em segundos) de uma sessao assumida via esta Role."
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "permissions_boundary_arn" {
  type        = string
  description = "ARN de uma permissions boundary opcional a ser aplicada a Role. Deixe vazio para nao usar."
  default     = ""
}

variable "trusted_principal_arns" {
  type        = list(string)
  description = "Lista de ARNs de principals (contas, roles ou usuarios) autorizados a assumir esta Role. Nunca deve conter \"*\"."

  validation {
    condition     = length(var.trusted_principal_arns) > 0
    error_message = "trusted_principal_arns deve conter ao menos um ARN de principal."
  }

  validation {
    condition     = !contains(var.trusted_principal_arns, "*")
    error_message = "trusted_principal_arns nao pode conter \"*\" (qualquer principal). Especifique ARNs concretos."
  }
}

variable "policy_name" {
  type        = string
  description = "Nome da IAM Policy a ser criada e anexada a Role."
  default     = "app-scoped-policy"
}

variable "policy_path" {
  type        = string
  description = "Path da IAM Policy."
  default     = "/"
}

variable "policy_description" {
  type        = string
  description = "Descricao da IAM Policy."
  default     = "Policy IAM com permissoes de minimo privilegio, sem acoes ou recursos com wildcard amplo."
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de acoes IAM permitidas pela policy. Evite acoes administrativas ou wildcard total (\"*\")."
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma acao."
  }

  validation {
    condition     = !contains(var.allowed_actions, "*")
    error_message = "allowed_actions nao pode conter \"*\" (todas as acoes). Especifique acoes concretas."
  }

  validation {
    condition     = !contains(var.allowed_actions, "iam:*")
    error_message = "allowed_actions nao pode conter \"iam:*\", pois concede privilegios administrativos sobre IAM."
  }
}

variable "resource_arns" {
  type        = list(string)
  description = "Lista de ARNs de recursos sobre os quais as acoes sao permitidas. Evite \"*\" sempre que possivel."
  default     = ["arn:aws:s3:::example-bucket/*"]

  validation {
    condition     = length(var.resource_arns) > 0
    error_message = "resource_arns deve conter ao menos um ARN de recurso."
  }

  validation {
    condition     = !contains(var.resource_arns, "*")
    error_message = "resource_arns nao pode conter \"*\" (todos os recursos). Especifique ARNs concretos."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas a Role e a Policy."
  default     = {}
}
