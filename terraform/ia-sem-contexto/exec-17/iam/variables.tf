variable "aws_region" {
  description = "Região AWS onde os recursos serão provisionados."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role."
  type        = string
  default     = "example-application-role"
}

variable "role_description" {
  description = "Descrição da IAM Role."
  type        = string
  default     = "Role de aplicacao com permissoes restritas, criada via Terraform."
}

variable "policy_name" {
  description = "Nome da IAM Policy."
  type        = string
  default     = "example-application-policy"
}

variable "policy_description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "Policy com permissoes minimas necessarias, anexada a uma unica role."
}

variable "path" {
  description = "Path utilizado tanto para a IAM Role quanto para a IAM Policy."
  type        = string
  default     = "/"
}

variable "principal_type" {
  description = "Tipo de principal autorizado a assumir a role: \"AWS\" (conta/role/usuario) ou \"Service\" (serviço AWS)."
  type        = string
  default     = "AWS"

  validation {
    condition     = contains(["AWS", "Service"], var.principal_type)
    error_message = "principal_type deve ser exatamente \"AWS\" ou \"Service\"."
  }
}

variable "principal_identifiers" {
  description = "Lista de ARNs (quando principal_type = \"AWS\") ou nomes de serviço, ex.: \"ec2.amazonaws.com\" (quando principal_type = \"Service\") autorizados a assumir a role. Nao pode conter \"*\" nem ficar vazia."
  type        = list(string)

  validation {
    condition     = length(var.principal_identifiers) > 0 && !contains(var.principal_identifiers, "*")
    error_message = "principal_identifiers nao pode ser vazio nem conter o wildcard \"*\". Especifique principais concretos."
  }
}

variable "external_id" {
  description = "ExternalId opcional exigido na trust policy (sts:AssumeRole), recomendado para acesso cross-account de terceiros."
  type        = string
  default     = null
}

variable "max_session_duration" {
  description = "Duracao maxima (em segundos) de uma sessao assumida pela role. Entre 3600 e 43200."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "force_detach_policies" {
  description = "Se true, forca a desvinculacao de policies anexadas quando a role for destruida."
  type        = bool
  default     = true
}

variable "permissions_boundary_arn" {
  description = "ARN opcional de uma policy de permissions boundary a ser aplicada a role."
  type        = string
  default     = null
}

variable "policy_actions" {
  description = "Lista de actions IAM permitidas pela policy. Nao pode ser vazia nem conter o wildcard amplo \"*\"."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.policy_actions) > 0 && !contains(var.policy_actions, "*")
    error_message = "policy_actions nao pode ser vazio nem conter o wildcard amplo \"*\". Especifique actions concretas."
  }
}

variable "policy_resources" {
  description = "Lista de ARNs de recursos aos quais a policy se aplica. Nao pode ser vazia nem conter o wildcard amplo \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.policy_resources) > 0 && !contains(var.policy_resources, "*")
    error_message = "policy_resources nao pode ser vazio nem conter o wildcard amplo \"*\". Especifique ARNs concretos."
  }
}

variable "tags" {
  description = "Tags aplicadas a IAM Role e a IAM Policy."
  type        = map(string)
  default     = {}
}
