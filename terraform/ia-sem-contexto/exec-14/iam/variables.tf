variable "region" {
  description = "Regiao AWS onde os recursos serao criados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "A regiao deve estar no formato ex: us-east-1."
  }
}

variable "policy_name" {
  description = "Nome da IAM Policy."
  type        = string
  default     = "tf-iam-policy"

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]{1,128}$", var.policy_name))
    error_message = "policy_name invalido. Use 1-128 chars: letras, numeros, e os simbolos +=,.@_-."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Managed by Terraform - example IAM policy"
}

variable "policy_path" {
  description = "Caminho da IAM Policy. Deve iniciar e terminar com '/'. Use '/' para raiz."
  type        = string
  default     = "/"

  validation {
    condition     = var.policy_path == "/" || can(regex("^/.*/$", var.policy_path))
    error_message = "policy_path deve ser '/' ou iniciar e terminar com '/'."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes AWS permitidas pela policy."
  type        = list(string)
  default     = ["sts:GetCallerIdentity"]

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions nao pode ser vazio."
  }
}

variable "resource_arns" {
  description = "Lista de ARNs (ou '*') sobre as quais as allowed_actions se aplicam."
  type        = list(string)
  default     = ["*"]

  validation {
    condition     = length(var.resource_arns) > 0
    error_message = "resource_arns nao pode ser vazio."
  }
}

variable "deny_actions" {
  description = "Opcional: lista de acoes a serem explicitamente negadas."
  type        = list(string)
  default     = []
}

variable "deny_resource_arns" {
  description = "Opcional: lista de ARNs (ou '*') para as acoes negadas."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags a serem aplicadas na IAM Policy."
  type        = map(string)
  default     = {}
}
