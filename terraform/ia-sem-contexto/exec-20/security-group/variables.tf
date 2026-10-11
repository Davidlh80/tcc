variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID da VPC (criada pelo ambiente de teste) onde o Security Group sera criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-zA-Z0-9]+$", var.vpc_id))
    error_message = "O valor de vpc_id deve ter o formato 'vpc-xxxxxxxx'."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "example-sg"
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security group gerenciado via Terraform"
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
      description = "Permite HTTPS a partir da rede interna"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
    }
  ]

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : contains(["tcp", "udp", "icmp", "-1"], rule.protocol)
    ])
    error_message = "O protocolo de cada regra de ingress deve ser um dos valores: tcp, udp, icmp, -1."
  }

  validation {
    condition = !anytrue([
      for rule in var.ingress_rules :
      contains(rule.cidr_blocks, "0.0.0.0/0") && rule.from_port == 0 && rule.to_port == 65535
    ])
    error_message = "Regras de ingress nao podem liberar todas as portas (0-65535) para 0.0.0.0/0."
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
      description = "Permite HTTPS de saida para acesso a APIs/repositorios"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  validation {
    condition = alltrue([
      for rule in var.egress_rules : contains(["tcp", "udp", "icmp", "-1"], rule.protocol)
    ])
    error_message = "O protocolo de cada regra de egress deve ser um dos valores: tcp, udp, icmp, -1."
  }

  validation {
    condition = !anytrue([
      for rule in var.egress_rules :
      contains(rule.cidr_blocks, "0.0.0.0/0") && rule.from_port == 0 && rule.to_port == 65535
    ])
    error_message = "Regras de egress nao podem liberar todas as portas (0-65535) para 0.0.0.0/0."
  }
}

variable "tags" {
  description = "Tags adicionais aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
