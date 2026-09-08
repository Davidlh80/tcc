variable "region" {
  description = "Regiao AWS onde os recursos serao criados."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string

  validation {
    condition     = length(var.vpc_id) > 0 && can(regex("^vpc-[0-9a-f]+$", var.vpc_id))
    error_message = "vpc_id deve corresponder ao padrao 'vpc-xxxxxxxx' (hexadecimal)."
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

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado por Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress). Pelo menos uma origem deve ser informada entre cidr_blocks, ipv6_cidr_blocks, prefix_list_ids ou source_security_group_id."
  type = list(object({
    description               = optional(string)
    protocol                  = string
    from_port                 = number
    to_port                   = number
    cidr_blocks               = optional(list(string))
    ipv6_cidr_blocks          = optional(list(string))
    prefix_list_ids           = optional(list(string))
    source_security_group_id  = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      r.from_port >= 0 && r.from_port <= 65535 &&
      r.to_port >= 0 && r.to_port <= 65535
    ])
    error_message = "Ingress: from_port e to_port devem estar entre 0 e 65535."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (
        try(length(r.cidr_blocks), 0) +
        try(length(r.ipv6_cidr_blocks), 0) +
        try(length(r.prefix_list_ids), 0) +
        (try(r.source_security_group_id, "") != "" ? 1 : 0)
      ) > 0
    ])
    error_message = "Ingress: cada regra deve definir ao menos uma origem (cidr_blocks, ipv6_cidr_blocks, prefix_list_ids ou source_security_group_id)."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida (egress). Por padrao, permite todo o trafego de saida para IPv4 e IPv6."
  type = list(object({
    description               = optional(string)
    protocol                  = string
    from_port                 = number
    to_port                   = number
    cidr_blocks               = optional(list(string))
    ipv6_cidr_blocks          = optional(list(string))
    prefix_list_ids           = optional(list(string))
    source_security_group_id  = optional(string)
  }))
  default = [
    {
      description      = "Allow all outbound IPv4 and IPv6"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      source_security_group_id = null
    }
  ]

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      r.from_port >= 0 && r.from_port <= 65535 &&
      r.to_port >= 0 && r.to_port <= 65535
    ])
    error_message = "Egress: from_port e to_port devem estar entre 0 e 65535."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (
        try(length(r.cidr_blocks), 0) +
        try(length(r.ipv6_cidr_blocks), 0) +
        try(length(r.prefix_list_ids), 0) +
        (try(r.source_security_group_id, "") != "" ? 1 : 0)
      ) > 0
    ])
    error_message = "Egress: cada regra deve definir ao menos um destino (cidr_blocks, ipv6_cidr_blocks, prefix_list_ids ou source_security_group_id)."
  }
}

variable "tags" {
  description = "Mapa de tags a serem aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
