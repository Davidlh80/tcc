variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]+$", var.vpc_id))
    error_message = "O valor de vpc_id deve seguir o formato 'vpc-xxxxxxxx'."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Managed by Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress) do Security Group. Nenhuma regra e criada por padrao."
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
      for rule in var.ingress_rules : rule.from_port >= 0 && rule.from_port <= 65535
    ])
    error_message = "from_port deve estar entre 0 e 65535."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : rule.to_port >= 0 && rule.to_port <= 65535
    ])
    error_message = "to_port deve estar entre 0 e 65535."
  }

  validation {
    condition = alltrue(flatten([
      for rule in var.ingress_rules : [
        for cidr in rule.cidr_blocks : can(cidrhost(cidr, 0))
      ]
    ]))
    error_message = "Todos os valores em cidr_blocks devem ser blocos CIDR validos."
  }

  validation {
    condition = alltrue(flatten([
      for rule in var.ingress_rules : [
        for cidr in rule.cidr_blocks : cidr != "0.0.0.0/0"
      ]
    ]))
    error_message = "Regras de ingress nao podem usar 0.0.0.0/0. Especifique origens restritas."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida (egress) do Security Group."
  type = list(object({
    description = optional(string, "")
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Permite todo trafego de saida"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  validation {
    condition = alltrue(flatten([
      for rule in var.egress_rules : [
        for cidr in rule.cidr_blocks : can(cidrhost(cidr, 0))
      ]
    ]))
    error_message = "Todos os valores em cidr_blocks devem ser blocos CIDR validos."
  }
}

variable "tags" {
  description = "Tags adicionais aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
