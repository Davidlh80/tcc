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

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255
    error_message = "O nome deve ter entre 1 e 255 caracteres."
  }
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Managed by Terraform"

  validation {
    condition     = length(var.description) > 0
    error_message = "A descricao nao pode ser vazia."
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada do Security Group."
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
      rule.from_port >= 0 && rule.from_port <= 65535 &&
      rule.to_port >= 0 && rule.to_port <= 65535 &&
      rule.from_port <= rule.to_port
    ])
    error_message = "As portas de entrada devem estar entre 0 e 65535, com from_port menor ou igual a to_port."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      contains(["tcp", "udp", "icmp", "-1"], rule.protocol)
    ])
    error_message = "O protocolo de cada regra de entrada deve ser um de: tcp, udp, icmp, -1."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      alltrue([
        for cidr in rule.cidr_blocks : can(cidrhost(cidr, 0))
      ])
    ])
    error_message = "Todos os CIDRs de entrada devem ser blocos IPv4 validos."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      length(rule.cidr_blocks) > 0
    ])
    error_message = "Cada regra de entrada deve conter ao menos um CIDR."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida do Security Group."
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
      for rule in var.egress_rules :
      rule.from_port >= 0 && rule.from_port <= 65535 &&
      rule.to_port >= 0 && rule.to_port <= 65535 &&
      rule.from_port <= rule.to_port
    ])
    error_message = "As portas de saida devem estar entre 0 e 65535, com from_port menor ou igual a to_port."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      contains(["tcp", "udp", "icmp", "-1"], rule.protocol)
    ])
    error_message = "O protocolo de cada regra de saida deve ser um de: tcp, udp, icmp, -1."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      alltrue([
        for cidr in rule.cidr_blocks : can(cidrhost(cidr, 0))
      ])
    ])
    error_message = "Todos os CIDRs de saida devem ser blocos IPv4 validos."
  }
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
