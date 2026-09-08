variable "region" {
  description = "Regiao AWS para o provider."
  type        = string
  default     = "us-east-1"
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "A regiao deve seguir o padrao, por exemplo: us-east-1, eu-west-1."
  }
}

variable "policy_name" {
  description = "Nome explicito da IAM Policy. Se nao definido, sera gerado a partir de name_prefix e um sufixo aleatorio."
  type        = string
  default     = null
  validation {
    condition = var.policy_name == null || (
      length(var.policy_name) >= 1 &&
      length(var.policy_name) <= 128 &&
      can(regex("^[A-Za-z0-9+=,.@_-]+$", var.policy_name))
    )
    error_message = "policy_name deve ter entre 1 e 128 caracteres e conter apenas A-Za-z0-9+=,.@_-."
  }
}

variable "name_prefix" {
  description = "Prefixo usado para compor o nome quando policy_name nao for informado."
  type        = string
  default     = "tf-iam-policy"
  validation {
    condition = (
      length(var.name_prefix) >= 1 &&
      length(var.name_prefix) <= 120 &&
      can(regex("^[A-Za-z0-9+=,.@_-]+$", var.name_prefix))
    )
    error_message = "name_prefix deve ter entre 1 e 120 caracteres e conter apenas A-Za-z0-9+=,.@_-."
  }
}

variable "description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Terraform managed IAM policy."
  validation {
    condition     = length(var.description) <= 1000
    error_message = "A descricao deve ter no maximo 1000 caracteres."
  }
}

variable "path" {
  description = "Caminho (path) da IAM Policy. Deve comecar e terminar com '/'."
  type        = string
  default     = "/"
  validation {
    condition     = startswith(var.path, "/") && endswith(var.path, "/")
    error_message = "O path deve comecar e terminar com '/'. Exemplo: '/', '/service-role/'."
  }
}

variable "tags" {
  description = "Tags a serem associadas a IAM Policy."
  type        = map(string)
  default     = {}
}

variable "statements" {
  description = "Lista de declaracoes (statements) da policy. Cada item deve definir exatamente um entre actions/not_actions e exatamente um entre resources/not_resources."
  type = list(object({
    sid           = optional(string)
    effect        = string
    actions       = optional(list(string))
    not_actions   = optional(list(string))
    resources     = optional(list(string))
    not_resources = optional(list(string))
    # conditions: map de operador (ex: StringEquals) para um map de variavel=>lista de valores
    # Ex.: { StringEquals = { "aws:PrincipalOrgID" = ["o-1234567890"] } }
    conditions = optional(map(map(list(string))))
  }))
  default = [
    {
      sid       = "DefaultReadIdentity"
      effect    = "Allow"
      actions   = ["sts:GetCallerIdentity", "iam:ListAccountAliases"]
      resources = ["*"]
    }
  ]
  validation {
    condition = length(var.statements) > 0 && alltrue([
      for s in var.statements :
      contains(["Allow", "Deny"], s.effect) &&
      (
        # exatamente um entre actions e not_actions
        ((try(length(s.actions), 0) > 0) != (try(length(s.not_actions), 0) > 0))
      ) &&
      (
        # exatamente um entre resources e not_resources
        ((try(length(s.resources), 0) > 0) != (try(length(s.not_resources), 0) > 0))
      )
    ])
    error_message = "Cada statement deve ter Effect em {Allow,Deny}, exatamente um entre actions/not_actions e exatamente um entre resources/not_resources."
  }
}
