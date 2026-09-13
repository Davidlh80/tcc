variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-f0-9]+$", var.vpc_id))
    error_message = "O valor de vpc_id deve ser um ID de VPC valido, no formato vpc-xxxxxxxx."
  }
}

variable "name" {
  description = "Nome base do Security Group (usado como prefixo e na tag Name)."
  type        = string
  default     = "sg-app"

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 200
    error_message = "O valor de name deve ter entre 1 e 200 caracteres."
  }
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Managed by Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress). Vazia por padrao para negar todo trafego de entrada."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      rule.from_port >= 0 && rule.from_port <= 65535 &&
      rule.to_port >= 0 && rule.to_port <= 65535 &&
      rule.from_port <= rule.to_port
    ])
    error_message = "Cada regra de ingress deve ter from_port e to_port entre 0 e 65535, com from_port <= to_port."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      contains(["tcp", "udp", "icmp", "-1"], rule.protocol)
    ])
    error_message = "O protocolo de cada regra de ingress deve ser um dos: tcp, udp, icmp, -1."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      length(rule.cidr_blocks) > 0
    ])
    error_message = "Cada regra de ingress deve especificar ao menos um CIDR em cidr_blocks."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida (egress). Por padrao permite todo o trafego de saida."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      rule.from_port >= 0 && rule.from_port <= 65535 &&
      rule.to_port >= 0 && rule.to_port <= 65535 &&
      rule.from_port <= rule.to_port
    ])
    error_message = "Cada regra de egress deve ter from_port e to_port entre 0 e 65535, com from_port <= to_port."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      contains(["tcp", "udp", "icmp", "-1"], rule.protocol)
    ])
    error_message = "O protocolo de cada regra de egress deve ser um dos: tcp, udp, icmp, -1."
  }
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
