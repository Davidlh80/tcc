variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID da VPC (criada pelo ambiente de teste) onde o Security Group sera provisionado."
  type        = string

  validation {
    condition     = length(var.vpc_id) > 0
    error_message = "O valor de vpc_id nao pode ser vazio."
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
      description = "Permite HTTPS a partir da rede interna confiavel"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    },
    {
      description = "Permite SSH a partir da rede interna confiavel"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  validation {
    condition     = alltrue([for rule in var.ingress_rules : !contains(rule.cidr_blocks, "0.0.0.0/0")])
    error_message = "Regras de entrada nao devem usar o CIDR irrestrito 0.0.0.0/0."
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
      description = "Permite saida HTTPS para atualizacoes e integracoes externas"
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
