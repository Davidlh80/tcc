variable "aws_region" {
  description = "Região AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d+$", var.aws_region))
    error_message = "Informe uma região AWS válida, por exemplo: us-east-1, eu-west-1."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = length(var.vpc_id) > 4 && startswith(var.vpc_id, "vpc-")
    error_message = "vpc_id deve ser um ID de VPC válido (ex: vpc-xxxxxxxxxxxxxxxxx)."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "sg-app"

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255
    error_message = "O nome deve ter entre 1 e 255 caracteres."
  }
}

variable "description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group managed by Terraform"

  validation {
    condition     = length(trim(var.description)) > 0
    error_message = "A descrição não pode ser vazia."
  }
}

variable "revoke_rules_on_delete" {
  description = "Revoga regras automaticamente ao destruir o Security Group (recomendado)."
  type        = bool
  default     = true
}

variable "ingress_rules" {
  description = "Lista de regras de entrada para o Security Group."
  type = list(object({
    description      = optional(string)
    protocol         = string
    from_port        = number
    to_port          = number
    cidr_blocks      = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    prefix_list_ids  = optional(list(string))
    security_groups  = optional(list(string))
    self             = optional(bool)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      r.from_port >= 0 && r.from_port <= 65535 &&
      r.to_port >= 0 && r.to_port <= 65535 &&
      r.to_port >= r.from_port
    ])
    error_message = "Ingress: from_port/to_port devem estar entre 0 e 65535 e to_port >= from_port."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída para o Security Group."
  type = list(object({
    description      = optional(string)
    protocol         = string
    from_port        = number
    to_port          = number
    cidr_blocks      = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    prefix_list_ids  = optional(list(string))
    security_groups  = optional(list(string))
    self             = optional(bool)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      r.from_port >= 0 && r.from_port <= 65535 &&
      r.to_port >= 0 && r.to_port <= 65535 &&
      r.to_port >= r.from_port
    ])
    error_message = "Egress: from_port/to_port devem estar entre 0 e 65535 e to_port >= from_port."
  }
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
