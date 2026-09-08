variable "region" {
  description = "Região AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    description   = "A região deve seguir o padrão, por exemplo: us-east-1, eu-west-1, ap-south-1."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-([0-9a-f]{8}|[0-9a-f]{17})$", var.vpc_id))
    description   = "vpc_id deve ser um ID de VPC válido (ex.: vpc-1234abcd ou vpc-1234567890abcdef0)."
  }
}

variable "sg_name" {
  description = "Nome do Security Group."
  type        = string
  default     = "secure-sg"

  validation {
    condition     = length(var.sg_name) >= 1 && length(var.sg_name) <= 255 && can(regex("^[A-Za-z0-9._-]+$", var.sg_name))
    description   = "O nome deve ter entre 1 e 255 caracteres e conter apenas A-Z, a-z, 0-9, ponto, sublinhado e hífen."
  }
}

variable "sg_description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado pelo Terraform"
}

variable "tags" {
  description = "Tags adicionais para o Security Group."
  type        = map(string)
  default     = {}
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress). Cada item permite múltiplas origens."
  type = list(object({
    description       = optional(string)
    from_port         = number
    to_port           = number
    protocol          = string                  // tcp, udp, icmp, icmpv6, -1
    cidr_blocks       = optional(list(string))  // Ex.: ["10.0.0.0/8"]
    ipv6_cidr_blocks  = optional(list(string))  // Ex.: ["::/0"]
    security_groups   = optional(list(string))  // IDs de SG permitidos como origem
    prefix_list_ids   = optional(list(string))  // Mantido para simetria (não usado em ingress)
    self              = optional(bool)          // true para permitir origem do próprio SG
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      r.from_port >= 0 && r.from_port <= 65535 &&
      r.to_port   >= r.from_port && r.to_port <= 65535
    ])
    description = "As portas devem estar entre 0 e 65535, e to_port >= from_port."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      contains(["tcp", "udp", "icmp", "icmpv6", "-1"], lower(r.protocol))
    ])
    description = "O protocolo deve ser um de: tcp, udp, icmp, icmpv6, -1."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída (egress). Cada item permite múltiplos destinos."
  type = list(object({
    description       = optional(string)
    from_port         = number
    to_port           = number
    protocol          = string                  // tcp, udp, icmp, icmpv6, -1
    cidr_blocks       = optional(list(string))  // Ex.: ["0.0.0.0/0"]
    ipv6_cidr_blocks  = optional(list(string))  // Ex.: ["::/0"]
    security_groups   = optional(list(string))  // IDs de SG permitidos como destino
    prefix_list_ids   = optional(list(string))  // Prefix lists (ex.: serviços AWS)
    self              = optional(bool)          // Mantido para compatibilidade; não é usado no egress block
  }))
  default = [
    {
      description      = "Permitir todo o tráfego de saída IPv4 e IPv6"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      r.from_port >= 0 && r.from_port <= 65535 &&
      r.to_port   >= r.from_port && r.to_port <= 65535
    ])
    description = "As portas devem estar entre 0 e 65535, e to_port >= from_port."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      contains(["tcp", "udp", "icmp", "icmpv6", "-1"], lower(r.protocol))
    ])
    description = "O protocolo deve ser um de: tcp, udp, icmp, icmpv6, -1."
  }
}
