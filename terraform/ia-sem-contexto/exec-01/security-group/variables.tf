variable "aws_region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID da VPC (criada pelo ambiente de teste) onde o Security Group sera provisionado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]+$", var.vpc_id))
    error_message = "O valor de vpc_id deve seguir o formato 'vpc-xxxxxxxx'."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "app-security-group"

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255
    error_message = "O nome do Security Group deve ter entre 1 e 255 caracteres."
  }
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security group gerenciado via Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada explicitas aplicadas ao Security Group."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Permite trafego HTTPS de entrada a partir da rede interna da VPC"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : (
        contains(["tcp", "udp", "icmp", "-1"], rule.protocol) &&
        rule.from_port >= -1 && rule.from_port <= 65535 &&
        rule.to_port >= -1 && rule.to_port <= 65535 &&
        rule.from_port <= rule.to_port
      )
    ])
    error_message = "Cada regra de ingress deve ter protocolo valido (tcp, udp, icmp ou -1) e portas entre -1 e 65535, com from_port <= to_port."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida explicitas aplicadas ao Security Group."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Permite trafego HTTPS de saida"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Permite resolucao DNS de saida (UDP)"
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  validation {
    condition = alltrue([
      for rule in var.egress_rules : (
        contains(["tcp", "udp", "icmp", "-1"], rule.protocol) &&
        rule.from_port >= -1 && rule.from_port <= 65535 &&
        rule.to_port >= -1 && rule.to_port <= 65535 &&
        rule.from_port <= rule.to_port
      )
    ])
    error_message = "Cada regra de egress deve ter protocolo valido (tcp, udp, icmp ou -1) e portas entre -1 e 65535, com from_port <= to_port."
  }
}

variable "tags" {
  description = "Tags adicionais aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
