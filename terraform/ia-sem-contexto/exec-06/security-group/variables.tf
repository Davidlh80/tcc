variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string
}

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

variable "ingress_rules" {
  description = "Lista de regras de entrada do Security Group."
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
    condition = alltrue([
      for rule in var.ingress_rules : rule.from_port >= 0 && rule.to_port <= 65535 && rule.from_port <= rule.to_port
    ])
    error_message = "As portas das regras de entrada devem estar entre 0 e 65535, com from_port menor ou igual a to_port."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : alltrue([
        for cidr in rule.cidr_blocks : cidr != "0.0.0.0/0"
      ])
    ])
    error_message = "Regras de entrada nao podem usar 0.0.0.0/0 como origem. Especifique CIDRs restritos."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida do Security Group."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Saida HTTPS para atualizacoes e integracoes externas"
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
