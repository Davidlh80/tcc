variable "aws_region" {
  description = "Regiao AWS onde os recursos serao criados."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string

  validation {
    condition     = length(trimspace(var.vpc_id)) > 0
    error_message = "O valor de vpc_id nao pode ser vazio."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "sg-default"

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "O valor de name nao pode ser vazio."
  }
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada do Security Group. Nenhuma regra de entrada e criada por padrao."
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
      for rule in var.ingress_rules : rule.from_port <= rule.to_port
    ])
    error_message = "Em cada regra de ingress_rules, from_port deve ser menor ou igual a to_port."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida do Security Group. Por padrao, permite todo o trafego de saida."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Permite todo o trafego de saida"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  validation {
    condition = alltrue([
      for rule in var.egress_rules : rule.from_port <= rule.to_port
    ])
    error_message = "Em cada regra de egress_rules, from_port deve ser menor ou igual a to_port."
  }
}

variable "tags" {
  description = "Tags adicionais aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
