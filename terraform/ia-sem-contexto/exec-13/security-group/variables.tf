variable "aws_region" {
  description = "Regiao AWS para o provider."
  type        = string
  default     = "us-east-1"
  validation {
    condition     = length(var.aws_region) > 0
    error_message = "aws_region nao pode ser vazio."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string
  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]+$", var.vpc_id))
    error_message = "vpc_id deve ter o formato 'vpc-xxxxxxxx'."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "secure-sg"
  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 255
    error_message = "O nome deve ter entre 1 e 255 caracteres."
  }
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Managed by Terraform"
}

variable "environment" {
  description = "Ambiente para tags padrao."
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "test", "staging", "prod"], var.environment)
    error_message = "environment deve ser um de: dev, test, staging, prod."
  }
}

variable "tags" {
  description = "Tags adicionais a serem associadas ao Security Group."
  type        = map(string)
  default     = {}
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress)."
  type = list(object({
    description        = optional(string, "")
    protocol           = string
    from_port          = number
    to_port            = number
    cidr_blocks        = optional(list(string), [])
    ipv6_cidr_blocks   = optional(list(string), [])
    prefix_list_ids    = optional(list(string), [])
    security_groups    = optional(list(string), [])
    self               = optional(bool, false)
  }))
  default = []
  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      r.from_port >= 0 && r.from_port <= 65535 &&
      r.to_port >= 0 && r.to_port <= 65535 &&
      r.from_port <= r.to_port
    ])
    error_message = "Ingress: portas devem estar entre 0 e 65535, e from_port <= to_port."
  }
  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      contains(["tcp", "udp", "icmp", "icmpv6", "-1"], lower(r.protocol))
    ])
    error_message = "Ingress: protocol deve ser um de: tcp, udp, icmp, icmpv6, -1."
  }
  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.prefix_list_ids) + length(r.security_groups)) > 0 || r.self == true
    ])
    error_message = "Ingress: cada regra deve definir pelo menos uma origem (cidr_blocks, ipv6_cidr_blocks, prefix_list_ids, security_groups) ou self=true."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida (egress). Por padrao permite todo trafego de saida (IPv4 e IPv6)."
  type = list(object({
    description        = optional(string, "")
    protocol           = string
    from_port          = number
    to_port            = number
    cidr_blocks        = optional(list(string), [])
    ipv6_cidr_blocks   = optional(list(string), [])
    prefix_list_ids    = optional(list(string), [])
    security_groups    = optional(list(string), [])
    self               = optional(bool, false)
  }))
  default = [
    {
      description      = "Allow all outbound IPv4 and IPv6"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
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
      r.from_port >= 0 && r.from_port <= 65535 &&
      r.to_port >= 0 && r.to_port <= 65535 &&
      r.from_port <= r.to_port
    ])
    error_message = "Egress: portas devem estar entre 0 e 65535, e from_port <= to_port."
  }
  validation {
    condition = alltrue([
      for r in var.egress_rules :
      contains(["tcp", "udp", "icmp", "icmpv6", "-1"], lower(r.protocol))
    ])
    error_message = "Egress: protocol deve ser um de: tcp, udp, icmp, icmpv6, -1."
  }
  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.prefix_list_ids) + length(r.security_groups)) > 0 || r.self == true
    ])
    error_message = "Egress: cada regra deve definir pelo menos um destino (cidr_blocks, ipv6_cidr_blocks, prefix_list_ids, security_groups) ou self=true."
  }
}
