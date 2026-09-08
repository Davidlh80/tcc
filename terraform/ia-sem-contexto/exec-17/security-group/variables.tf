variable "region" {
  description = "Regiao AWS a ser usada pelo provider."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(var.region) > 0
    error_message = "A regiao nao pode ser vazia."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado (ex.: vpc-xxxxxxxx)."
  type        = string

  validation {
    condition     = length(var.vpc_id) > 4 && startswith(var.vpc_id, "vpc-")
    error_message = "Informe um VPC ID valido (ex.: vpc-0123456789abcdef0)."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "tf-secgroup"

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255
    error_message = "O nome do Security Group deve ter entre 1 e 255 caracteres."
  }
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Managed by Terraform - Security Group"
}

variable "tags" {
  description = "Map de tags adicionais a aplicar no Security Group."
  type        = map(string)
  default     = {}
}

variable "ingress_cidr_rules" {
  description = "Regras de entrada baseadas em CIDRs."
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_cidr_rules :
      r.from_port >= 0 && r.to_port >= r.from_port && r.to_port <= 65535 &&
      contains(["-1", "tcp", "udp", "icmp", "icmpv6"], r.protocol)
    ])
    error_message = "Cada regra de ingress CIDR deve ter portas validas (0-65535) e protocolo em [-1, tcp, udp, icmp, icmpv6]."
  }
}

variable "ingress_sg_rules" {
  description = "Regras de entrada referenciando Security Groups."
  type = list(object({
    description               = string
    from_port                 = number
    to_port                   = number
    protocol                  = string
    source_security_group_id  = string
    self                      = bool
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_sg_rules :
      r.from_port >= 0 && r.to_port >= r.from_port && r.to_port <= 65535 &&
      contains(["-1", "tcp", "udp", "icmp", "icmpv6"], r.protocol)
    ])
    error_message = "Cada regra de ingress SG deve ter portas validas (0-65535) e protocolo em [-1, tcp, udp, icmp, icmpv6]."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_sg_rules :
      r.self || startswith(r.source_security_group_id, "sg-")
    ])
    error_message = "Cada regra de ingress SG deve ter self=true ou um source_security_group_id iniciando com 'sg-'."
  }
}

variable "egress_cidr_rules" {
  description = "Regras de saida baseadas em CIDRs."
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
  }))

  default = [
    {
      description      = "Allow all egress"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

  validation {
    condition = alltrue([
      for r in var.egress_cidr_rules :
      r.from_port >= 0 && r.to_port >= r.from_port && r.to_port <= 65535 &&
      contains(["-1", "tcp", "udp", "icmp", "icmpv6"], r.protocol)
    ])
    error_message = "Cada regra de egress CIDR deve ter portas validas (0-65535) e protocolo em [-1, tcp, udp, icmp, icmpv6]."
  }
}

variable "egress_sg_rules" {
  description = "Regras de saida referenciando Security Groups."
  type = list(object({
    description                    = string
    from_port                      = number
    to_port                        = number
    protocol                       = string
    destination_security_group_id  = string
    self                           = bool
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.egress_sg_rules :
      r.from_port >= 0 && r.to_port >= r.from_port && r.to_port <= 65535 &&
      contains(["-1", "tcp", "udp", "icmp", "icmpv6"], r.protocol)
    ])
    error_message = "Cada regra de egress SG deve ter portas validas (0-65535) e protocolo em [-1, tcp, udp, icmp, icmpv6]."
  }

  validation {
    condition = alltrue([
      for r in var.egress_sg_rules :
      r.self || startswith(r.destination_security_group_id, "sg-")
    ])
    error_message = "Cada regra de egress SG deve ter self=true ou um destination_security_group_id iniciando com 'sg-'."
  }
}
