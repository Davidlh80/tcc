variable "environment" {
  description = "Ambiente de implantacao do recurso."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou aplicacao ao qual o recurso pertence."
  type        = string
  default     = "tcc"

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde o recurso sera provisionado."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(trimspace(var.region)) > 0
    error_message = "O valor de region nao pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas as tags obrigatorias do recurso."
  type        = map(string)
  default     = {}
}

variable "security_group_name" {
  description = "Finalidade do Security Group, utilizada na composicao do nome padronizado (ex.: web, database, bastion)."
  type        = string

  validation {
    condition     = length(trimspace(var.security_group_name)) > 0
    error_message = "O valor de security_group_name nao pode ser vazio."
  }
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string

  validation {
    condition     = length(trimspace(var.description)) > 0
    error_message = "O valor de description nao pode ser vazio."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-", var.vpc_id))
    error_message = "O valor de vpc_id deve ser um ID de VPC valido, iniciado com 'vpc-'."
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada do Security Group. Cada regra exige descricao. O CIDR 0.0.0.0/0 so e permitido para a porta 443/tcp."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.ingress_rules : length(trimspace(r.description)) > 0])
    error_message = "Toda regra de ingress deve conter uma descricao nao vazia."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      !contains(r.cidr_blocks, "0.0.0.0/0") || (r.protocol == "tcp" && r.from_port == 443 && r.to_port == 443)
    ])
    error_message = "O CIDR 0.0.0.0/0 so e permitido em regras de ingress na porta 443/tcp."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida do Security Group. Cada regra exige descricao. O CIDR 0.0.0.0/0 so e permitido para a porta 443/tcp."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Permite trafego de saida HTTPS para atualizacoes e integracoes externas."
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  validation {
    condition     = alltrue([for r in var.egress_rules : length(trimspace(r.description)) > 0])
    error_message = "Toda regra de egress deve conter uma descricao nao vazia."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      !contains(r.cidr_blocks, "0.0.0.0/0") || (r.protocol == "tcp" && r.from_port == 443 && r.to_port == 443)
    ])
    error_message = "O CIDR 0.0.0.0/0 so e permitido em regras de egress na porta 443/tcp."
  }
}
