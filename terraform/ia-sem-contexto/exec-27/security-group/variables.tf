variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-f0-9]+$", var.vpc_id))
    error_message = "O valor de vpc_id deve ser um ID de VPC valido (ex: vpc-0123456789abcdef0)."
  }
}

variable "name" {
  description = "Nome do Security Group. Se vazio, um nome padrao sera gerado com base em environment."
  type        = string
  default     = ""
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Managed by Terraform"
}

variable "environment" {
  description = "Nome do ambiente (ex: dev, staging, prod), usado para nomear e taguear o recurso."
  type        = string
  default     = "dev"
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
      description = "Acesso HTTPS interno"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
    }
  ]

  validation {
    condition     = alltrue([for rule in var.ingress_rules : !contains(rule.cidr_blocks, "0.0.0.0/0") || rule.from_port != 0 || rule.to_port != 65535])
    error_message = "Regras de ingresso nao podem liberar todas as portas (0-65535) para 0.0.0.0/0."
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
      description = "Saida HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Saida HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
