variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(trim(var.region)) > 0
    error_message = "A variavel region nao pode ser vazia."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]+$", var.vpc_id))
    error_message = "vpc_id deve corresponder ao padrao vpc-xxxxxxxx."
  }
}

variable "sg_name" {
  description = "Nome do Security Group."
  type        = string
  default     = "example-sg"

  validation {
    condition     = length(trim(var.sg_name)) > 0 && length(var.sg_name) <= 255
    error_message = "sg_name deve ser nao-vazio e ter no maximo 255 caracteres."
  }
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado por Terraform"

  validation {
    condition     = length(trim(var.description)) > 0
    error_message = "description nao pode ser vazia."
  }
}

variable "revoke_rules_on_delete" {
  description = "Revogar regras antes de deletar o security group (recomendado para garantir remocao limpa)."
  type        = bool
  default     = true
}

variable "enable_name_tag" {
  description = "Se verdadeiro, adiciona a tag Name com o valor de sg_name."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}

variable "ingress_rules" {
  description = "Lista de regras de entrada para o Security Group."
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string            # ex: tcp, udp, icmp, icmpv6 ou -1
    cidr_blocks      = list(string)      # ex: [\"10.0.0.0/16\"]
    ipv6_cidr_blocks = list(string)      # ex: [\"::/0\"]
    prefix_list_ids  = list(string)      # ex: [\"pl-xxxxxxxx\"]
    security_groups  = list(string)      # SGs de origem (mesma VPC)
    self             = bool              # true para permitir do proprio SG
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      contains(["-1", "tcp", "udp", "icmp", "icmpv6"], lower(r.protocol))
    ])
    error_message = "ingress_rules.protocol deve ser um de: -1, tcp, udp, icmp, icmpv6."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      r.from_port >= 0 && r.to_port >= 0 && r.to_port <= 65535 && r.from_port <= r.to_port
    ])
    error_message = "ingress_rules: from_port e to_port devem estar entre 0 e 65535 e from_port <= to_port."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.prefix_list_ids) + length(r.security_groups) + (r.self ? 1 : 0)) > 0
    ])
    error_message = "Cada regra de ingress deve ter pelo menos uma origem (cidr_blocks, ipv6_cidr_blocks, prefix_list_ids, security_groups ou self=true)."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida para o Security Group."
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string            # ex: tcp, udp, icmp, icmpv6 ou -1
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    prefix_list_ids  = list(string)
    security_groups  = list(string)      # SGs de destino (mesma VPC)
    self             = bool              # true para permitir destino o proprio SG
  }))
  # Padrao seguro e funcional: permitir todo trafego de saida (IPv4 e IPv6)
  default = [
    {
      description      = "Allow all outbound IPv4 and IPv6"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      contains(["-1", "tcp", "udp", "icmp", "icmpv6"], lower(r.protocol))
    ])
    error_message = "egress_rules.protocol deve ser um de: -1, tcp, udp, icmp, icmpv6."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      r.from_port >= 0 && r.to_port >= 0 && r.to_port <= 65535 && r.from_port <= r.to_port
    ])
    error_message = "egress_rules: from_port e to_port devem estar entre 0 e 65535 e from_port <= to_port."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.prefix_list_ids) + length(r.security_groups) + (r.self ? 1 : 0)) > 0
    ])
    error_message = "Cada regra de egress deve ter pelo menos um destino (cidr_blocks, ipv6_cidr_blocks, prefix_list_ids, security_groups ou self=true)."
  }
}
