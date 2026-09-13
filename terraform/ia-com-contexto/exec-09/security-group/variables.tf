variable "environment" {
  type        = string
  description = "Ambiente de implantacao do recurso (dev, hml ou prd)."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema ou aplicacao ao qual o recurso pertence."

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  type        = string
  description = "Regiao AWS onde o recurso sera criado."
  default     = "us-east-1"
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais aplicadas ao recurso, alem das tags obrigatorias definidas pela organizacao."
  default     = {}
}

variable "security_group_name" {
  type        = string
  description = "Finalidade do Security Group, utilizada na composicao do nome padronizado <ambiente>-<sistema>-sg-<finalidade>."

  validation {
    condition     = length(trimspace(var.security_group_name)) > 0
    error_message = "O valor de security_group_name nao pode ser vazio."
  }
}

variable "vpc_id" {
  type        = string
  description = "ID da VPC onde o Security Group sera criado."

  validation {
    condition     = length(trimspace(var.vpc_id)) > 0
    error_message = "O valor de vpc_id nao pode ser vazio."
  }
}

variable "description" {
  type        = string
  description = "Descricao do Security Group."
  default     = "Security Group gerenciado via Terraform."

  validation {
    condition     = length(trimspace(var.description)) > 0
    error_message = "O valor de description nao pode ser vazio."
  }
}

variable "ingress_rules" {
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "Lista de regras de entrada do Security Group. O CIDR 0.0.0.0/0 somente e permitido em regras 443/tcp."
  default     = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules : length(trimspace(r.description)) > 0
    ])
    error_message = "Toda regra de ingress deve conter uma descricao nao vazia."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      !contains(r.cidr_blocks, "0.0.0.0/0") || (r.protocol == "tcp" && r.from_port == 443 && r.to_port == 443)
    ])
    error_message = "O CIDR 0.0.0.0/0 so e permitido em regras de porta 443/tcp."
  }
}

variable "egress_rules" {
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "Lista de regras de saida do Security Group. Nao ha liberacao irrestrita por padrao; o CIDR 0.0.0.0/0 somente e permitido em regras 443/tcp."
  default     = []

  validation {
    condition = alltrue([
      for r in var.egress_rules : length(trimspace(r.description)) > 0
    ])
    error_message = "Toda regra de egress deve conter uma descricao nao vazia."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      !contains(r.cidr_blocks, "0.0.0.0/0") || (r.protocol == "tcp" && r.from_port == 443 && r.to_port == 443)
    ])
    error_message = "O CIDR 0.0.0.0/0 so e permitido em regras de porta 443/tcp."
  }
}
