variable "aws_region" {
  description = "Regiao AWS utilizada pelo provider."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado. Deve ser a VPC provisionada pelo proprio ambiente de teste, nao a VPC default da conta."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-z0-9]+$", var.vpc_id))
    error_message = "O valor de vpc_id deve ser um ID de VPC valido, iniciando com 'vpc-'."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "sg-app"
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada explicitas do Security Group. Nenhuma regra e criada por padrao."
  type = list(object({
    description     = string
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string), [])
    security_groups = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : rule.from_port <= rule.to_port
    ])
    error_message = "Em cada regra de ingress_rules, from_port deve ser menor ou igual a to_port."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida explicitas do Security Group. Nenhuma regra e criada por padrao."
  type = list(object({
    description     = string
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string), [])
    security_groups = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.egress_rules : rule.from_port <= rule.to_port
    ])
    error_message = "Em cada regra de egress_rules, from_port deve ser menor ou igual a to_port."
  }
}

variable "tags" {
  description = "Tags adicionais aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
