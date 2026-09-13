variable "aws_region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-zA-Z0-9]+$", var.vpc_id))
    error_message = "O valor de vpc_id deve seguir o formato 'vpc-xxxxxxxx'."
  }
}

variable "name_prefix" {
  description = "Prefixo usado para nomear o Security Group e seus recursos relacionados."
  type        = string
  default     = "app"

  validation {
    condition     = can(regex("^[a-z0-9-]{1,32}$", var.name_prefix))
    error_message = "name_prefix deve conter apenas letras minusculas, numeros e hifens, com no maximo 32 caracteres."
  }
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Managed by Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress) do Security Group. Vazia por padrao (nenhuma porta aberta)."
  type = list(object({
    description = optional(string, "")
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
    error_message = "Cada regra de ingress deve ter from_port e to_port entre 0 e 65535, com from_port menor ou igual a to_port."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      alltrue([for cidr in rule.cidr_blocks : can(cidrhost(cidr, 0))])
    ])
    error_message = "Todos os cidr_blocks das regras de ingress devem ser blocos CIDR validos."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida (egress) do Security Group. Por padrao permite todo trafego de saida."
  type = list(object({
    description = optional(string, "")
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Permitir todo o trafego de saida"
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
    error_message = "Cada regra de egress deve ter from_port e to_port entre 0 e 65535, com from_port menor ou igual a to_port."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      alltrue([for cidr in rule.cidr_blocks : can(cidrhost(cidr, 0))])
    ])
    error_message = "Todos os cidr_blocks das regras de egress devem ser blocos CIDR validos."
  }
}

variable "tags" {
  description = "Tags adicionais aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
