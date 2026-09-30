variable "aws_region" {
  description = "Regiao AWS onde os recursos IAM serao provisionados (IAM e global, mas o provider exige uma regiao)."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string
  default     = "app-execution-role"
}

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "Role de execucao com permissoes minimas necessarias para a aplicacao."
}

variable "role_path" {
  description = "Path da IAM Role e da IAM Policy dentro do IAM."
  type        = string
  default     = "/"
}

variable "max_session_duration" {
  description = "Duracao maxima (em segundos) de uma sessao assumida com esta role. Deve estar entre 3600 e 43200, conforme limite do IAM."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "force_detach_policies" {
  description = "Se true, forca o desanexamento de policies ao destruir a role."
  type        = bool
  default     = false
}

variable "permissions_boundary_arn" {
  description = "ARN de uma policy a ser usada como permissions boundary para a role. Nulo desabilita o boundary."
  type        = string
  default     = null
}

variable "external_id" {
  description = "ExternalId opcional exigido na condicao sts:ExternalId do assume role policy. Nulo desabilita a condicao."
  type        = string
  default     = null
}

variable "trusted_principals" {
  description = "Lista de principals de confianca autorizados a assumir a role (sts:AssumeRole). Por padrao, apenas o servico EC2 pode assumi-la."
  type = list(object({
    type        = string
    identifiers = list(string)
  }))
  default = [
    {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  ]

  validation {
    condition     = length(var.trusted_principals) > 0
    error_message = "trusted_principals nao pode ser uma lista vazia: a role precisa de ao menos um principal de confianca."
  }

  validation {
    condition = alltrue([
      for p in var.trusted_principals : contains(["AWS", "Service", "Federated", "CanonicalUser"], p.type)
    ])
    error_message = "O campo type de cada principal deve ser AWS, Service, Federated ou CanonicalUser."
  }

  validation {
    condition = alltrue([
      for p in var.trusted_principals : length(p.identifiers) > 0
    ])
    error_message = "Cada principal deve possuir ao menos um identifier."
  }
}

variable "policy_name" {
  description = "Nome da IAM Policy anexada a role."
  type        = string
  default     = "app-execution-policy"
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy com permissoes minimas necessarias para a aplicacao, anexada a IAM Role correspondente."
}

variable "policy_statements" {
  description = "Statements da IAM Policy anexada a role. Nao permite acoes ou recursos com wildcard total ('*'), forcando escopo explicito."
  type = list(object({
    sid       = string
    effect    = string
    actions   = list(string)
    resources = list(string)
    conditions = list(object({
      test     = string
      variable = string
      values   = list(string)
    }))
  }))

  default = [
    {
      sid        = "AllowReadOnlyOnApplicationBucket"
      effect     = "Allow"
      actions    = ["s3:GetObject", "s3:ListBucket"]
      resources  = ["arn:aws:s3:::example-app-bucket", "arn:aws:s3:::example-app-bucket/*"]
      conditions = []
    }
  ]

  validation {
    condition     = length(var.policy_statements) > 0
    error_message = "policy_statements nao pode ser uma lista vazia: a policy precisa de ao menos um statement."
  }

  validation {
    condition = alltrue([
      for s in var.policy_statements : contains(["Allow", "Deny"], s.effect)
    ])
    error_message = "O campo effect de cada statement deve ser Allow ou Deny."
  }

  validation {
    condition = alltrue([
      for s in var.policy_statements : !contains(s.actions, "*")
    ])
    error_message = "Nao e permitido usar a acao wildcard '*' em nenhum statement. Especifique as acoes necessarias."
  }

  validation {
    condition = alltrue([
      for s in var.policy_statements : !contains(s.resources, "*")
    ])
    error_message = "Nao e permitido usar o recurso wildcard '*' em nenhum statement. Especifique os ARNs necessarios."
  }
}

variable "tags" {
  description = "Tags adicionais aplicadas a IAM Role e a IAM Policy."
  type        = map(string)
  default     = {}
}
