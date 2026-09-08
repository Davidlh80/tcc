variable "region" {
  type        = string
  description = "Regiao AWS onde os recursos serao criados."
  default     = "us-east-1"

  validation {
    condition     = length(var.region) >= 5
    error_message = "A regiao deve ser um identificador valido (ex: us-east-1)."
  }
}

variable "vpc_id" {
  type        = string
  description = "ID da VPC onde o Security Group sera criado."
  nullable    = false

  validation {
    condition     = can(regex("^vpc-[0-9a-f]{8,17}$", var.vpc_id))
    error_message = "vpc_id deve corresponder ao padrao 'vpc-xxxxxxxx' (ou 17 hex)."
  }
}

variable "name" {
  type        = string
  description = "Nome do Security Group."
  default     = "sg-managed"

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255
    error_message = "O nome deve ter entre 1 e 255 caracteres."
  }
}

variable "description" {
  type        = string
  description = "Descricao do Security Group."
  default     = "Security Group gerenciado por Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress). Por padrao, vazio (nenhuma entrada liberada)."
  type = list(object({
    description       = optional(string)
    from_port         = number
    to_port           = number
    protocol          = string
    cidr_blocks       = optional(list(string), [])
    ipv6_cidr_blocks  = optional(list(string), [])
    security_groups   = optional(list(string), [])
    self              = optional(bool, false)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (
        (
          r.protocol == "-1" && r.from_port == 0 && r.to_port == 0
        )
        ||
        (
          r.protocol != "-1"
          && r.from_port >= 0 && r.from_port <= 65535
          && r.to_port >= 0 && r.to_port <= 65535
          && r.from_port <= r.to_port
        )
      )
    ])
    error_message = "Para cada regra ingress: se protocol = -1, from_port e to_port devem ser 0; caso contrario, portas devem estar entre 0-65535 e from_port <= to_port."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.security_groups) + (r.self ? 1 : 0)) > 0
    ])
    error_message = "Cada regra ingress deve definir pelo menos uma origem: cidr_blocks, ipv6_cidr_blocks, security_groups ou self=true."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida (egress). Por padrao, saida liberada para 0.0.0.0/0."
  type = list(object({
    description       = optional(string)
    from_port         = number
    to_port           = number
    protocol          = string
    cidr_blocks       = optional(list(string), [])
    ipv6_cidr_blocks  = optional(list(string), [])
    security_groups   = optional(list(string), [])
    self              = optional(bool, false)
  }))
  default = [
    {
      description      = "Allow all egress (IPv4)"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      security_groups  = []
      self             = false
    }
  ]

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (
        (
          r.protocol == "-1" && r.from_port == 0 && r.to_port == 0
        )
        ||
        (
          r.protocol != "-1"
          && r.from_port >= 0 && r.from_port <= 65535
          && r.to_port >= 0 && r.to_port <= 65535
          && r.from_port <= r.to_port
        )
      )
    ])
    error_message = "Para cada regra egress: se protocol = -1, from_port e to_port devem ser 0; caso contrario, portas devem estar entre 0-65535 e from_port <= to_port."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.security_groups) + (r.self ? 1 : 0)) > 0
    ])
    error_message = "Cada regra egress deve definir pelo menos um destino: cidr_blocks, ipv6_cidr_blocks, security_groups ou self=true."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais aplicadas ao Security Group."
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : length(k) > 0 && length(v) >= 0])
    error_message = "As chaves de tags nao podem ser vazias."
  }
}
