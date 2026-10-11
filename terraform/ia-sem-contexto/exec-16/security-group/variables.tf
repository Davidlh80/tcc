variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "app-sg"
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform"
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado. Deve ser a VPC provisionada pelo ambiente de teste, nao a VPC default da conta."
  type        = string
}

variable "ingress_rules" {
  description = "Lista de regras de entrada explicitas. Cada regra define protocolo, portas, CIDRs de origem e descricao."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Acesso HTTPS a partir da rede interna"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  validation {
    condition     = alltrue([for rule in var.ingress_rules : !contains(rule.cidr_blocks, "0.0.0.0/0")])
    error_message = "Regras de entrada nao devem permitir acesso irrestrito (0.0.0.0/0)."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida explicitas. Cada regra define protocolo, portas, CIDRs de destino e descricao."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Saida HTTPS para atualizacoes e chamadas externas"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "tags" {
  description = "Tags adicionais aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
