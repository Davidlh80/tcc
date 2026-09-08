variable "aws_region" {
  description = "Região AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(regexall("^(us|af|ap|ca|eu|il|me|sa)-[a-z]+-\\d$", var.aws_region)) > 0
    error_message = "A região AWS informada não é válida (ex.: us-east-1, eu-west-1)."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = length(regexall("^vpc-([0-9a-f]{8}|[0-9a-f]{17})$", var.vpc_id)) > 0
    error_message = "O VPC ID deve seguir o formato 'vpc-xxxxxxxx' ou 'vpc-xxxxxxxxxxxxxxxxx'."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "secure-sg"

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 255
    error_message = "O nome do Security Group deve ter entre 1 e 255 caracteres."
  }
}

variable "sg_description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security group gerenciado por Terraform"

  validation {
    condition     = length(var.sg_description) >= 1 && length(var.sg_description) <= 255
    error_message = "A descrição deve ter entre 1 e 255 caracteres."
  }
}

variable "enable_name_tag" {
  description = "Se verdadeiro, adiciona a tag Name com o valor do nome do SG."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags adicionais para o Security Group."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : !startswith(k, "aws:")])
    error_message = "As chaves de tag não podem começar com 'aws:'."
  }
}

variable "ingress_rules" {
  description = <<EOT
Lista de regras de entrada. Cada item aceita:
- description (opcional)
- from_port, to_port, protocol ("tcp", "udp", "icmp", "icmpv6" ou "-1")
- Defina pelo menos um dos destinos: cidr_blocks, ipv6_cidr_blocks, prefix_list_ids, source_security_group_id
EOT
  type = list(object({
    description              = optional(string, "")
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = optional(list(string), [])
    ipv6_cidr_blocks         = optional(list(string), [])
    prefix_list_ids          = optional(list(string), [])
    source_security_group_id = optional(string, "")
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (r.from_port >= -1) && (r.to_port >= -1) && (r.to_port <= 65535) && (r.from_port <= r.to_port)
    ])
    error_message = "Ingress: from_port/to_port devem estar no intervalo [-1..65535] e from_port <= to_port."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      contains(["-1", "tcp", "udp", "icmp", "icmpv6"], lower(r.protocol))
    ])
    error_message = "Ingress: protocolo deve ser um de: -1, tcp, udp, icmp, icmpv6."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.prefix_list_ids) + (trimspace(r.source_security_group_id) != "" ? 1 : 0)) > 0
    ])
    error_message = "Ingress: cada regra deve definir pelo menos uma origem: cidr_blocks, ipv6_cidr_blocks, prefix_list_ids ou source_security_group_id."
  }
}

variable "egress_rules" {
  description = <<EOT
Lista de regras de saída. Cada item aceita:
- description (opcional)
- from_port, to_port, protocol ("tcp", "udp", "icmp", "icmpv6" ou "-1")
- Defina pelo menos um dos destinos: cidr_blocks, ipv6_cidr_blocks, prefix_list_ids
Observação: referência a SG de destino em egress não é suportada neste módulo.
EOT
  type = list(object({
    description      = optional(string, "")
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
    prefix_list_ids  = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (r.from_port >= -1) && (r.to_port >= -1) && (r.to_port <= 65535) && (r.from_port <= r.to_port)
    ])
    error_message = "Egress: from_port/to_port devem estar no intervalo [-1..65535] e from_port <= to_port."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      contains(["-1", "tcp", "udp", "icmp", "icmpv6"], lower(r.protocol))
    ])
    error_message = "Egress: protocolo deve ser um de: -1, tcp, udp, icmp, icmpv6."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.prefix_list_ids)) > 0
    ])
    error_message = "Egress: cada regra deve definir pelo menos um destino: cidr_blocks, ipv6_cidr_blocks ou prefix_list_ids."
  }
}
