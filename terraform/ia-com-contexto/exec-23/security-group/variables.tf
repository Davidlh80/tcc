variable "environment" {
  description = "Ambiente de implantacao do recurso (dev, hml ou prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou projeto ao qual o recurso pertence, utilizado na composicao do nome padronizado."
  type        = string

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao da AWS onde os recursos serao criados."
  type        = string

  validation {
    condition     = length(trimspace(var.region)) > 0
    error_message = "O valor de region nao pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string

  validation {
    condition     = length(trimspace(var.vpc_id)) > 0
    error_message = "O valor de vpc_id nao pode ser vazio."
  }
}

variable "security_group_name" {
  description = "Finalidade do Security Group, utilizada para compor o nome padronizado <ambiente>-<sistema>-sg-<finalidade> (ex.: web, api, database)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.security_group_name))
    error_message = "O valor de security_group_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "description" {
  description = "Descricao geral do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform."

  validation {
    condition     = length(trimspace(var.description)) > 0
    error_message = "O valor de description nao pode ser vazio."
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada do Security Group. Toda regra deve conter descricao obrigatoria. 0.0.0.0/0 somente e permitido em regras de porta 443/tcp."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : trimspace(rule.description) != ""
    ])
    error_message = "Toda regra de ingress deve conter uma descricao nao vazia."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      !contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.from_port == 443 && rule.to_port == 443 && rule.protocol == "tcp")
    ])
    error_message = "0.0.0.0/0 somente e permitido em regras restritas a porta 443/tcp."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida do Security Group. Toda regra deve conter descricao obrigatoria. 0.0.0.0/0 somente e permitido em regras de porta 443/tcp. Nao ha liberacao irrestrita por padrao."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.egress_rules : trimspace(rule.description) != ""
    ])
    error_message = "Toda regra de egress deve conter uma descricao nao vazia."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      !contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.from_port == 443 && rule.to_port == 443 && rule.protocol == "tcp")
    ])
    error_message = "0.0.0.0/0 somente e permitido em regras restritas a porta 443/tcp."
  }
}
