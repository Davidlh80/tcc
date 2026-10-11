variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado. Deve ser a VPC provisionada pelo ambiente de teste, nao a VPC default da conta."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]+$", var.vpc_id))
    error_message = "O valor de vpc_id deve ser um ID de VPC valido, no formato vpc-xxxxxxxx."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "app-sg"
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada explicitas. Nao defina regras com cidr_blocks contendo 0.0.0.0/0 a menos que seja estritamente necessario."
  type = list(object({
    description = optional(string, "Regra de entrada gerenciada via Terraform")
    from_port   = number
    to_port     = number
    protocol    = optional(string, "tcp")
    cidr_blocks = list(string)
  }))
  default = []

  validation {
    condition = alltrue(flatten([
      for rule in var.ingress_rules : [
        for cidr in rule.cidr_blocks : can(cidrhost(cidr, 0))
      ]
    ]))
    error_message = "Todos os valores em cidr_blocks das regras de ingress devem ser blocos CIDR validos."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : rule.from_port <= rule.to_port
    ])
    error_message = "Em cada regra de ingress, from_port deve ser menor ou igual a to_port."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida explicitas. O padrao libera apenas HTTPS (443) para a internet, evitando liberacao irrestrita de todas as portas."
  type = list(object({
    description = optional(string, "Regra de saida gerenciada via Terraform")
    from_port   = number
    to_port     = number
    protocol    = optional(string, "tcp")
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Permite trafego HTTPS de saida"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  validation {
    condition = alltrue(flatten([
      for rule in var.egress_rules : [
        for cidr in rule.cidr_blocks : can(cidrhost(cidr, 0))
      ]
    ]))
    error_message = "Todos os valores em cidr_blocks das regras de egress devem ser blocos CIDR validos."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules : rule.from_port <= rule.to_port
    ])
    error_message = "Em cada regra de egress, from_port deve ser menor ou igual a to_port."
  }
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
