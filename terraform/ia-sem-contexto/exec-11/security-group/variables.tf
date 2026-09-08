variable "aws_region" {
  description = "Região AWS onde os recursos serão provisionados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(var.aws_region) > 0
    error_message = "aws_region não pode ser vazio."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado (ex.: vpc-0123456789abcdef0)."
  type        = string

  validation {
    condition     = length(var.vpc_id) > 0
    error_message = "vpc_id é obrigatório e não pode ser vazio."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "sg-app"

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255
    error_message = "name deve ter entre 1 e 255 caracteres."
  }
}

variable "description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado pelo Terraform"

  validation {
    condition     = length(var.description) > 0 && length(var.description) <= 255
    error_message = "description deve ter entre 1 e 255 caracteres."
  }
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}

variable "rules" {
  description = "Lista de regras do Security Group. Cada regra deve definir tipo (ingress/egress), protocolo, portas e uma origem/destino (CIDRs IPv4/IPv6, prefix list, SG ou self)."
  type = list(object({
    description             = optional(string)
    type                    = string                      # ingress | egress
    protocol                = string                      # tcp | udp | icmp | icmpv6 | -1
    from_port               = number
    to_port                 = number
    cidr_blocks             = optional(list(string), [])
    ipv6_cidr_blocks        = optional(list(string), [])
    prefix_list_ids         = optional(list(string), [])
    source_security_group_id = optional(string)
    self                    = optional(bool, false)
  }))

  # Padrão seguro: somente saída HTTPS (IPv4 e IPv6)
  default = [
    {
      description      = "Permite saída HTTPS (IPv4 e IPv6)"
      type             = "egress"
      protocol         = "tcp"
      from_port        = 443
      to_port          = 443
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      self             = false
    }
  ]

  validation {
    condition = alltrue([
      for r in var.rules :
      contains(["ingress", "egress"], lower(r.type))
    ])
    error_message = "Cada regra deve ter type igual a 'ingress' ou 'egress'."
  }

  validation {
    condition = alltrue([
      for r in var.rules :
      contains(["-1", "tcp", "udp", "icmp", "icmpv6"], lower(r.protocol))
    ])
    error_message = "Cada regra deve ter protocol em ['-1', 'tcp', 'udp', 'icmp', 'icmpv6']."
  }

  validation {
    condition = alltrue([
      for r in var.rules :
      r.from_port >= 0 && r.from_port <= 65535 &&
      r.to_port >= 0 && r.to_port <= 65535 &&
      r.to_port >= r.from_port
    ])
    error_message = "As portas devem estar no intervalo 0-65535 e to_port >= from_port."
  }

  validation {
    condition = alltrue([
      for r in var.rules : (
        (length(try(r.cidr_blocks, [])) + length(try(r.ipv6_cidr_blocks, [])) > 0 ? 1 : 0) +
        (length(try(r.prefix_list_ids, [])) > 0 ? 1 : 0) +
        (try(r.source_security_group_id, null) != null ? 1 : 0) +
        (try(r.self, false) ? 1 : 0)
      ) == 1
    ])
    error_message = "Cada regra deve especificar exatamente UMA origem/destino entre: (cidr_blocks e/ou ipv6_cidr_blocks), OU prefix_list_ids, OU source_security_group_id, OU self=true."
  }
}
