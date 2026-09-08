variable "aws_region" {
  description = "Regiao AWS onde os recursos serao criados."
  type        = string
  default     = "us-east-1"
  validation {
    condition     = length(var.aws_region) > 0
    error_message = "A regiao AWS nao pode ser vazia."
  }
}

variable "policy_name" {
  description = "Nome exato da IAM Policy. Se nulo, sera usado name_prefix."
  type        = string
  default     = null
  validation {
    condition     = var.policy_name == null || can(regex("^[\\w+=,.@-]{1,128}$", var.policy_name))
    error_message = "policy_name deve corresponder ao padrao IAM: [A-Za-z0-9+=,.@_-], max 128 caracteres."
  }
}

variable "policy_name_prefix" {
  description = "Prefixo para o nome da policy quando policy_name nao for definido."
  type        = string
  default     = "custom-"
  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,64}$", var.policy_name_prefix))
    error_message = "policy_name_prefix deve corresponder ao padrao IAM e ter ate 64 caracteres."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy gerenciada pelo Terraform."
}

variable "policy_path" {
  description = "Caminho (path) da IAM Policy. Deve iniciar e terminar com '/'."
  type        = string
  default     = "/customer-managed/"
  validation {
    condition     = startswith(var.policy_path, "/") && endswith(var.policy_path, "/")
    error_message = "policy_path deve iniciar e terminar com '/'. Ex.: /customer-managed/."
  }
}

variable "tags" {
  description = "Tags a serem aplicadas na IAM Policy."
  type        = map(string)
  default     = {}
}

variable "statements" {
  description = "Lista de statements que compoem o documento da policy. Cada statement contem actions, resources e opcoes como effect, sid e conditions."
  type = list(object({
    sid       = optional(string)
    effect    = optional(string) # Allow ou Deny
    actions   = set(string)
    resources = set(string)
    conditions = optional(list(object({
      test     = string          # Ex.: StringEquals, ArnLike, Bool, NumericLessThan, etc.
      variable = string          # Ex.: aws:PrincipalOrgID, s3:prefix, etc.
      values   = set(string)
    })))
  }))
  default = []
  validation {
    condition     = var.statements == [] || alltrue([for s in var.statements : length(s.actions) > 0 && length(s.resources) > 0])
    error_message = "Cada statement deve conter pelo menos uma action e um resource."
  }
}
