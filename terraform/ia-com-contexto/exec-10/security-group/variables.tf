variable "region" {
  description = "Região AWS onde os recursos serão provisionados."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d+$", var.region))
    error_message = "A região deve estar no formato válido da AWS (ex.: us-east-1, sa-east-1)."
  }
}

variable "environment" {
  description = "Ambiente de implantação. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/produto (minúsculas, números e hífens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Mapa de tags adicionais a serem aplicadas aos recursos."
  type        = map(string)
  default     = {}
}

variable "security_group_name" {
  description = "Finalidade do Security Group (usado na composição do nome)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.security_group_name)) && length(var.security_group_name) > 0
    error_message = "security_group_name deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "security_group_description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado por Terraform."
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]+$", var.vpc_id))
    error_message = "vpc_id deve estar no formato válido (ex.: vpc-xxxxxxxx)."
  }
}

variable "ingress_rules" {
  description = <<EOT
Lista de regras de entrada. Cada item deve conter:
- description (string, obrigatório)
- protocol (string: tcp|udp|icmp|icmpv6|-1)
- from_port (number)
- to_port (number)
- cidr_blocks (list(string), opcional)
- ipv6_cidr_blocks (list(string), opcional)
- source_security_group_ids (list(string), opcional)
Observações de segurança:
- É proibido 0.0.0.0/0 em qualquer porta além da 443/tcp.
- É recomendado evitar ::/0 (IPv6) exceto 443/tcp.
- Toda regra deve possuir descrição.
- Pelo menos uma origem deve ser informada (CIDR IPv4, IPv6 ou SG).
EOT
  type = list(object({
    description               = string
    protocol                  = string
    from_port                 = number
    to_port                   = number
    cidr_blocks               = optional(list(string), [])
    ipv6_cidr_blocks          = optional(list(string), [])
    source_security_group_ids = optional(list(string), [])
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.ingress_rules : length(trim(r.description)) > 0])
    error_message = "Toda regra de entrada deve possuir 'description' não vazia."
  }

  validation {
    condition     = alltrue([for r in var.ingress_rules : contains(["tcp", "udp", "icmp", "icmpv6", "-1"], lower(r.protocol))])
    error_message = "Ingress: 'protocol' deve ser um de: tcp, udp, icmp, icmpv6, -1."
  }

  validation {
    condition     = alltrue([for r in var.ingress_rules : r.from_port >= 0 && r.from_port <= 65535 && r.to_port >= 0 && r.to_port <= 65535 && r.to_port >= r.from_port])
    error_message = "Ingress: 'from_port' e 'to_port' devem estar em 0..65535 e to_port >= from_port."
  }

  validation {
    condition     = alltrue([for r in var.ingress_rules : (length(try(r.cidr_blocks, [])) + length(try(r.ipv6_cidr_blocks, [])) + length(try(r.source_security_group_ids, []))) > 0])
    error_message = "Ingress: cada regra deve informar ao menos uma origem: cidr_blocks, ipv6_cidr_blocks ou source_security_group_ids."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      length([for c in try(r.cidr_blocks, []) : c if c == "0.0.0.0/0"]) == 0
      || (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
    ])
    error_message = "Ingress: 0.0.0.0/0 só é permitido para tcp/443."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      length([for c in try(r.ipv6_cidr_blocks, []) : c if c == "::/0"]) == 0
      || (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
    ])
    error_message = "Ingress: ::/0 (IPv6) só é recomendado/permitido para tcp/443."
  }
}

variable "egress_rules" {
  description = <<EOT
Lista de regras de saída explícitas (sem liberação irrestrita por padrão). Cada item deve conter:
- description (string, obrigatório)
- protocol (string: tcp|udp|icmp|icmpv6|-1)
- from_port (number)
- to_port (number)
- cidr_blocks (list(string), opcional)
- ipv6_cidr_blocks (list(string), opcional)
- source_security_group_ids (list(string), opcional) — destinos SG
Observações de segurança:
- É proibido 0.0.0.0/0 em qualquer porta além da 443/tcp.
- É recomendado evitar ::/0 (IPv6) exceto 443/tcp.
- Toda regra deve possuir descrição.
- Pelo menos um destino deve ser informado (CIDR IPv4, IPv6 ou SG).
EOT
  type = list(object({
    description               = string
    protocol                  = string
    from_port                 = number
    to_port                   = number
    cidr_blocks               = optional(list(string), [])
    ipv6_cidr_blocks          = optional(list(string), [])
    source_security_group_ids = optional(list(string), [])
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.egress_rules : length(trim(r.description)) > 0])
    error_message = "Egress: toda regra deve possuir 'description' não vazia."
  }

  validation {
    condition     = alltrue([for r in var.egress_rules : contains(["tcp", "udp", "icmp", "icmpv6", "-1"], lower(r.protocol))])
    error_message = "Egress: 'protocol' deve ser um de: tcp, udp, icmp, icmpv6, -1."
  }

  validation {
    condition     = alltrue([for r in var.egress_rules : r.from_port >= 0 && r.from_port <= 65535 && r.to_port >= 0 && r.to_port <= 65535 && r.to_port >= r.from_port])
    error_message = "Egress: 'from_port' e 'to_port' devem estar em 0..65535 e to_port >= from_port."
  }

  validation {
    condition     = alltrue([for r in var.egress_rules : (length(try(r.cidr_blocks, [])) + length(try(r.ipv6_cidr_blocks, [])) + length(try(r.source_security_group_ids, []))) > 0])
    error_message = "Egress: cada regra deve informar ao menos um destino: cidr_blocks, ipv6_cidr_blocks ou source_security_group_ids."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      length([for c in try(r.cidr_blocks, []) : c if c == "0.0.0.0/0"]) == 0
      || (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
    ])
    error_message = "Egress: 0.0.0.0/0 só é permitido para tcp/443."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      length([for c in try(r.ipv6_cidr_blocks, []) : c if c == "::/0"]) == 0
      || (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
    ])
    error_message = "Egress: ::/0 (IPv6) só é recomendado/permitido para tcp/443."
  }
}
