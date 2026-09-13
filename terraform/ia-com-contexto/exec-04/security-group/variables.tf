variable "environment" {
  description = "Ambiente de implantacao do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome curto do sistema ou produto ao qual o recurso pertence, utilizado na composicao do nome padronizado."
  type        = string

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde o Security Group sera criado."
  type        = string

  validation {
    condition     = length(var.region) > 0
    error_message = "O valor de region nao pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas as tags obrigatorias do recurso."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string

  validation {
    condition     = length(var.vpc_id) > 0
    error_message = "O valor de vpc_id nao pode ser vazio."
  }
}

variable "security_group_name" {
  description = "Finalidade do Security Group, utilizada na composicao do nome padronizado <ambiente>-<sistema>-sg-<finalidade> (ex.: web, database, bastion)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.security_group_name))
    error_message = "O valor de security_group_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "security_group_description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform."

  validation {
    condition     = length(var.security_group_description) > 0
    error_message = "O valor de security_group_description nao pode ser vazio."
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada do Security Group. Toda regra deve ter descricao e o CIDR 0.0.0.0/0 so e permitido para a porta 443/tcp."
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
      for rule in var.ingress_rules :
      length(rule.description) > 0 &&
      (!contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.protocol == "tcp" && rule.from_port == 443 && rule.to_port == 443))
    ])
    error_message = "Toda regra de entrada deve ter descricao nao vazia, e o CIDR 0.0.0.0/0 so e permitido em regras que liberem exclusivamente a porta 443/tcp."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida do Security Group. Toda regra deve ter descricao e o CIDR 0.0.0.0/0 so e permitido para a porta 443/tcp. Nao ha liberacao irrestrita por padrao."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  default = [
    {
      description = "Permite trafego de saida HTTPS para a internet."
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      length(rule.description) > 0 &&
      (!contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.protocol == "tcp" && rule.from_port == 443 && rule.to_port == 443))
    ])
    error_message = "Toda regra de saida deve ter descricao nao vazia, e o CIDR 0.0.0.0/0 so e permitido em regras que liberem exclusivamente a porta 443/tcp."
  }
}
