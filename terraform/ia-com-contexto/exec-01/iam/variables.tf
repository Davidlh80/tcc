variable "environment" {
  description = "Ambiente de implantacao do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou aplicacao ao qual o recurso pertence, usado na composicao do nome padronizado."
  type        = string

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos de IAM serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas as tags obrigatorias definidas pela organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da IAM Policy/Role, usada na composicao do nome padronizado (ex.: readonly, deploy, logging)."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "O valor de policy_name nao pode ser vazio."
  }
}

variable "trusted_principal_arn" {
  description = "ARN unico do principal (usuario, role ou conta) autorizado a assumir a IAM Role via trust policy. Nao pode ser curinga (\"*\")."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws[a-zA-Z-]*:iam::", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM valido e explicito (ex.: arn:aws:iam::123456789012:role/nome), sem uso de curinga."
  }
}

variable "actions" {
  description = "Lista de IAM actions permitidas (Effect Allow) na policy gerenciada."
  type        = list(string)

  validation {
    condition     = length(var.actions) > 0
    error_message = "A lista de actions nao pode ser vazia."
  }
}

variable "resources" {
  description = "Lista de ARNs de recursos aos quais as actions da policy se aplicam (Effect Allow)."
  type        = list(string)

  validation {
    condition     = length(var.resources) > 0
    error_message = "A lista de resources nao pode ser vazia."
  }
}
