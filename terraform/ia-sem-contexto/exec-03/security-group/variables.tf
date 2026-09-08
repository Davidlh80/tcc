variable "aws_region" {
  description = "Regiao AWS onde os recursos serao criados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(var.aws_region) > 0
    error_message = "A regiao AWS nao pode ser vazia."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado (ex: vpc-0123456789abcdef0)."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]+$", var.vpc_id))
    error_message = "Informe um VPC ID valido iniciando com 'vpc-'."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "sg-example"

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255 && can(regex("^[A-Za-z0-9-_]+$", var.name))
    error_message = "O nome deve conter apenas letras, numeros, '-', '_' e ter no maximo 255 caracteres."
  }
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado pelo Terraform"
}

variable "tags" {
  description = "Tags adicionais para associar ao Security Group."
  type        = map(string)
  default     = {}
}

variable "revoke_rules_on_delete" {
  description = "Se verdadeiro, revoga regras antes de destruir o SG (recomendado)."
  type        = bool
  default     = true
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress). Deixe vazio para negar todo ingress por padrao."
  type = list(object({
    description         = optional(string, null)
    protocol            = string                          # 'tcp', 'udp', 'icmp', 'icmpv6' ou '-1'
    from_port           = number                          # Para ICMP pode ser -1
    to_port             = number                          # Para ICMP pode ser -1
    cidr_blocks         = optional(list(string), [])
    ipv6_cidr_blocks    = optional(list(string), [])
    prefix_list_ids     = optional(list(string), [])
    security_group_ids  = optional(list(string), [])
    self                = optional(bool, false)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules : (
        contains(["tcp", "udp", "icmp", "icmpv6", "-1"], lower(r.protocol))
        && r.to_port >= r.from_port
        && r.from_port >= -1
        && r.to_port <= 65535
        && (
          length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.prefix_list_ids) + length(r.security_group_ids) + (r.self ? 1 : 0)
        ) > 0
      )
    ])
    error_message = "Cada regra de ingress deve ter protocolo valido, portas coerentes (from_port <= to_port; valores entre -1 e 65535) e pelo menos um alvo (cidr, ipv6, prefix-list, security group) ou self=true."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida (egress). Por padrao, permite todo trafego de saida IPv4 e IPv6."
  type = list(object({
    description         = optional(string, null)
    protocol            = string
    from_port           = number
    to_port             = number
    cidr_blocks         = optional(list(string), [])
    ipv6_cidr_blocks    = optional(list(string), [])
    prefix_list_ids     = optional(list(string), [])
    security_group_ids  = optional(list(string), [])
    self                = optional(bool, false)
  }))
  default = [
    {
      description      = "Allow all outbound IPv4"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_group_ids = []
      self             = false
    },
    {
      description      = "Allow all outbound IPv6"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      cidr_blocks      = []
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_group_ids = []
      self             = false
    }
  ]

  validation {
    condition = alltrue([
      for r in var.egress_rules : (
        contains(["tcp", "udp", "icmp", "icmpv6", "-1"], lower(r.protocol))
        && r.to_port >= r.from_port
        && r.from_port >= -1
        && r.to_port <= 65535
        && (
          length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.prefix_list_ids) + length(r.security_group_ids) + (r.self ? 1 : 0)
        ) > 0
      )
    ])
    error_message = "Cada regra de egress deve ter protocolo valido, portas coerentes (from_port <= to_port; valores entre -1 e 65535) e pelo menos um alvo (cidr, ipv6, prefix-list, security group) ou self=true."
  }
}
