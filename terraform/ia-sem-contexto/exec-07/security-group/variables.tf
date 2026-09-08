variable "aws_region" {
  description = "Regiao AWS onde os recursos serao provisionados."
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
    condition     = can(regex("^vpc-[0-9a-fA-F]{8,}$", var.vpc_id))
    error_message = "vpc_id deve corresponder ao padrao de IDs de VPC (ex: vpc-xxxxxxxx ou vpc-xxxxxxxxxxxxxxxxx)."
  }
}

variable "name" {
  description = "Nome do Security Group. Se null, sera usado name_prefix."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Prefixo para o nome do Security Group quando name for null."
  type        = string
  default     = "tf-sg-"

  validation {
    condition     = length(var.name_prefix) > 0
    error_message = "name_prefix nao pode ser vazio."
  }
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado por Terraform"
}

variable "tags" {
  description = "Tags adicionais a aplicar no Security Group."
  type        = map(string)
  default     = {}
}

variable "ingress_rules" {
  description = <<EOT
Lista de regras de entrada (ingress). Cada item aceita:
- description: string (opcional)
- from_port: number
- to_port: number
- protocol: string (ex: tcp, udp, icmp, icmpv6, sctp, ou -1 para todos)
- cidr_blocks: lista de CIDRs IPv4 (opcional)
- ipv6_cidr_blocks: lista de CIDRs IPv6 (opcional)
- security_groups: lista de IDs de SGs de origem (opcional)
Observacao: cada destino informado gera uma regra separada.
EOT
  type = list(object({
    description      = optional(string)
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    security_groups  = optional(list(string))
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (
        // portas dentro de faixa razoavel
        r.from_port >= -1 && r.from_port <= 65535 &&
        r.to_port >= -1 && r.to_port <= 65535
      )
    ])
    error_message = "from_port e to_port nas regras de ingress devem estar entre -1 e 65535."
  }
}

variable "egress_rules" {
  description = <<EOT
Lista de regras de saida (egress). Cada item aceita:
- description: string (opcional)
- from_port: number
- to_port: number
- protocol: string (ex: tcp, udp, icmp, icmpv6, sctp, ou -1 para todos)
- cidr_blocks: lista de CIDRs IPv4 (opcional)
- ipv6_cidr_blocks: lista de CIDRs IPv6 (opcional)
- security_groups: lista de IDs de SGs de destino (opcional)
Observacao: por padrao, nenhuma saida e permitida (egress = []). Adicione regras aqui para liberar trafego de saida explicitamente.
EOT
  type = list(object({
    description      = optional(string)
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    security_groups  = optional(list(string))
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (
        r.from_port >= -1 && r.from_port <= 65535 &&
        r.to_port >= -1 && r.to_port <= 65535
      )
    ])
    error_message = "from_port e to_port nas regras de egress devem estar entre -1 e 65535."
  }
}
