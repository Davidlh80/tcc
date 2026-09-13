variable "aws_region" {
  description = "Regiao AWS utilizada pelo provider."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string
}

variable "name" {
  description = "Nome base do Security Group (usado como prefixo do recurso e na tag Name)."
  type        = string
  default     = "app-sg"
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress). Por padrao, nenhuma porta e liberada (deny all)."
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
      for rule in var.ingress_rules : rule.from_port <= rule.to_port
    ])
    error_message = "Em cada regra de ingress_rules, from_port deve ser menor ou igual a to_port."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : length(rule.cidr_blocks) > 0
    ])
    error_message = "Cada regra de ingress_rules deve conter ao menos um CIDR em cidr_blocks."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida (egress). Por padrao, libera todo o trafego de saida."
  type = list(object({
    description = optional(string, "")
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  validation {
    condition = alltrue([
      for rule in var.egress_rules : length(rule.cidr_blocks) > 0
    ])
    error_message = "Cada regra de egress_rules deve conter ao menos um CIDR em cidr_blocks."
  }
}

variable "tags" {
  description = "Tags adicionais aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
