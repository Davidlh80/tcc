variable "environment" {
  description = "Ambiente de implantacao do recurso."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou aplicacao proprietaria do recurso, utilizado na composicao do nome padronizado."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.system))
    error_message = "O valor de system deve conter apenas letras minusculas, numeros e hifens, sem espacos."
  }
}

variable "region" {
  description = "Regiao AWS de referencia para o provider. O IAM e um servico global, mas o valor e exigido para padronizacao e auditoria entre execucoes."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "O valor de region deve seguir o formato de uma regiao AWS valida, por exemplo us-east-1."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas as tags obrigatorias definidas pela organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da IAM Policy, utilizada para compor o nome no padrao <ambiente>-<sistema>-iam-<finalidade> (ex.: readonly)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.policy_name))
    error_message = "O valor de policy_name deve conter apenas letras minusculas, numeros e hifens, sem espacos."
  }
}

variable "policy_description" {
  description = "Descricao funcional da IAM Policy."
  type        = string
  default     = "Policy gerenciada via Terraform seguindo padroes organizacionais de menor privilegio."
}

variable "allowed_actions" {
  description = "Lista de actions IAM permitidas explicitamente na statement Allow da policy."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma action."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos permitidos explicitamente na statement Allow da policy."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }
}
