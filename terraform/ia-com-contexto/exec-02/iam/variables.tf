variable "environment" {
  description = "Ambiente de implantacao do recurso."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome curto do sistema ou projeto ao qual o recurso pertence, usado na composicao do nome padronizado."
  type        = string

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias definidas pela organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da IAM Policy/Role, usada na composicao do nome padronizado (ex.: readonly, deploy)."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "O valor de policy_name nao pode ser vazio."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy criada."
  type        = string
  default     = "Policy gerenciada via Terraform com permissoes restritas as acoes e recursos configurados por variavel."
}

variable "trusted_principal_arn" {
  description = "ARN unico do principal autorizado a assumir a IAM Role (trust policy). Nao pode ser curinga."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws[a-zA-Z-]*:iam::\\d{12}:(role|user|root)(/.*)?$", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM valido e especifico (role, user ou root), sem curinga."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas na policy (Effect Allow)."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma acao."
  }

  validation {
    condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
    error_message = "Nao e permitido combinar Action \"*\" com Resource \"*\" na mesma policy."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos permitidos na policy (Effect Allow)."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }
}
