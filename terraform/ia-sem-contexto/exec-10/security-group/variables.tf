variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-z0-9]+$", var.vpc_id))
    error_message = "O valor de vpc_id deve seguir o formato 'vpc-xxxxxxxx'."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "example-sg"
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform."
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress) do Security Group."
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
      for rule in var.ingress_rules : contains(["tcp", "udp", "icmp", "-1"], rule.protocol)
    ])
    error_message = "O protocolo de cada regra de ingress deve ser um dos valores: tcp, udp, icmp ou -1."
  }

  validation {
    condition = alltrue(flatten([
      for rule in var.ingress_rules : [
        for cidr in rule.cidr_blocks : can(cidrhost(cidr, 0))
      ]
    ]))
    error_message = "Todos os CIDRs informados em ingress_rules devem ser blocos CIDR validos."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida (egress) do Security Group."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Permite todo o trafego de saida."
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  validation {
    condition = alltrue([
      for rule in var.egress_rules : contains(["tcp", "udp", "icmp", "-1"], rule.protocol)
    ])
    error_message = "O protocolo de cada regra de egress deve ser um dos valores: tcp, udp, icmp ou -1."
  }

  validation {
    condition = alltrue(flatten([
      for rule in var.egress_rules : [
        for cidr in rule.cidr_blocks : can(cidrhost(cidr, 0))
      ]
    ]))
    error_message = "Todos os CIDRs informados em egress_rules devem ser blocos CIDR validos."
  }
}

variable "tags" {
  description = "Mapa de tags adicionais a serem aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
