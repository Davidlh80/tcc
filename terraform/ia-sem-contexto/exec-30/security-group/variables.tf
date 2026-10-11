variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-", var.vpc_id))
    error_message = "O valor de vpc_id deve ser um ID de VPC valido, iniciando com 'vpc-'."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "sg-managed"
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform."
}

variable "ingress_rules" {
  description = "Lista de regras de entrada explicitas do Security Group."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Permite trafego HTTPS a partir da rede interna da VPC."
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  validation {
    condition     = alltrue([for rule in var.ingress_rules : rule.from_port >= 0 && rule.to_port <= 65535 && rule.from_port <= rule.to_port])
    error_message = "Cada regra de ingress deve ter from_port <= to_port, dentro do intervalo 0-65535."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida explicitas do Security Group."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Permite trafego HTTPS de saida para atualizacoes e chamadas a servicos externos."
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  validation {
    condition     = alltrue([for rule in var.egress_rules : rule.from_port >= 0 && rule.to_port <= 65535 && rule.from_port <= rule.to_port])
    error_message = "Cada regra de egress deve ter from_port <= to_port, dentro do intervalo 0-65535."
  }
}

variable "tags" {
  description = "Tags adicionais aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
