variable "environment" {
  description = "Ambiente de implantacao do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser 'dev', 'hml' ou 'prd'."
  }
}

variable "system" {
  description = "Nome do sistema ou aplicacao ao qual o recurso pertence, utilizado na composicao do nome padronizado."
  type        = string

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string

  validation {
    condition     = length(var.region) > 0
    error_message = "O valor de region nao pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias do recurso."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade/nome da IAM Policy, utilizado na composicao do nome padronizado do recurso."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "O valor de policy_name nao pode ser vazio."
  }
}

variable "role_name" {
  description = "Finalidade/nome da IAM Role, utilizado na composicao do nome padronizado do recurso."
  type        = string

  validation {
    condition     = length(var.role_name) > 0
    error_message = "O valor de role_name nao pode ser vazio."
  }
}

variable "policy_description" {
  description = "Descricao associada a IAM Policy criada."
  type        = string
  default     = "Policy gerenciada via Terraform com privilegios restritos as acoes e recursos configurados."
}

variable "trusted_principal_type" {
  description = "Tipo do principal de confianca utilizado na trust policy (assume role policy) da IAM Role. Valores permitidos: AWS, Service."
  type        = string

  validation {
    condition     = contains(["AWS", "Service"], var.trusted_principal_type)
    error_message = "O valor de trusted_principal_type deve ser 'AWS' ou 'Service'."
  }
}

variable "trusted_principal_identifiers" {
  description = "Lista de identificadores do principal de confianca da trust policy (ex.: ARN de uma role/usuario/conta especifica, ou um service principal como 'ec2.amazonaws.com'). O valor '*' nao e permitido."
  type        = list(string)

  validation {
    condition     = length(var.trusted_principal_identifiers) > 0 && !contains(var.trusted_principal_identifiers, "*")
    error_message = "trusted_principal_identifiers deve conter ao menos um identificador e nao pode conter o valor '*'."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas (Effect Allow) na policy criada."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma acao."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs/recursos permitidos (Effect Allow) na policy criada."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }
}
