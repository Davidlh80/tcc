variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string
}

variable "aws_region" {
  description = "Regiao AWS utilizada pelo provider."
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "app-security-group"

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255
    error_message = "O nome deve ter entre 1 e 255 caracteres."
  }
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform."
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress) do Security Group. Vazia por padrao, seguindo o principio de menor privilegio."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : alltrue([
        for cidr in rule.cidr_blocks : can(cidrhost(cidr, 0))
      ])
    ])
    error_message = "Todos os cidr_blocks das regras de ingress devem ser blocos CIDR validos."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida (egress) do Security Group."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Permite todo o trafego de saida"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  validation {
    condition = alltrue([
      for rule in var.egress_rules : alltrue([
        for cidr in rule.cidr_blocks : can(cidrhost(cidr, 0))
      ])
    ])
    error_message = "Todos os cidr_blocks das regras de egress devem ser blocos CIDR validos."
  }
}

variable "tags" {
  description = "Tags adicionais aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
