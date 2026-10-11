variable "aws_region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID da VPC (criada pelo ambiente de teste) onde o Security Group sera criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]{8,17}$", var.vpc_id))
    error_message = "O valor de vpc_id deve ser um ID de VPC valido, no formato 'vpc-xxxxxxxx'."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "sg-managed-by-terraform"
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security group gerenciado via Terraform."
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
    condition     = alltrue([for rule in var.ingress_rules : !contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.from_port == rule.to_port && rule.from_port != 22 && rule.from_port != 3389)])
    error_message = "Regras de entrada com origem 0.0.0.0/0 nao podem expor portas administrativas (22/3389)."
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
    }
  ]
}

variable "tags" {
  description = "Tags adicionais aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
