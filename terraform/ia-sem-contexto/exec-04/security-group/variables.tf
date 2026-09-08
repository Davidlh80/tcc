variable "aws_region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d+$", var.aws_region))
    error_message = "aws_region deve estar no formato esperado, por exemplo: us-east-1."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string

  validation {
    condition     = length(trim(var.vpc_id)) > 4 && startswith(var.vpc_id, "vpc-")
    error_message = "vpc_id deve ser um ID valido iniciado por 'vpc-'."
  }
}

variable "sg_name" {
  description = "Nome do Security Group."
  type        = string
  default     = "secure-sg"

  validation {
    condition     = length(trim(var.sg_name)) >= 1 && length(var.sg_name) <= 255
    error_message = "sg_name deve possuir entre 1 e 255 caracteres."
  }
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform."
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress). Por padrao, nenhuma regra de entrada e criada."
  type = list(object({
    description        = optional(string, null)
    from_port          = number
    to_port            = number
    protocol           = string
    cidr_blocks        = optional(list(string), [])
    ipv6_cidr_blocks   = optional(list(string), [])
    security_group_ids = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (
        can(regex("^(tcp|udp|icmp|icmpv6|-1|[0-9]+)$", r.protocol))
        &&
        (r.protocol == "-1" || (r.from_port >= 0 && r.from_port <= 65535 && r.to_port >= 0 && r.to_port <= 65535 && r.to_port >= r.from_port))
        &&
        (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.security_group_ids) > 0)
      )
    ])
    error_message = "Cada regra de ingress deve ter protocolo valido, portas coerentes (ou -1) e pelo menos uma origem (cidr_blocks, ipv6_cidr_blocks ou security_group_ids)."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida (egress). Por padrao, nenhuma regra de saida e criada (tudo bloqueado)."
  type = list(object({
    description        = optional(string, null)
    from_port          = number
    to_port            = number
    protocol           = string
    cidr_blocks        = optional(list(string), [])
    ipv6_cidr_blocks   = optional(list(string), [])
    security_group_ids = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (
        can(regex("^(tcp|udp|icmp|icmpv6|-1|[0-9]+)$", r.protocol))
        &&
        (r.protocol == "-1" || (r.from_port >= 0 && r.from_port <= 65535 && r.to_port >= 0 && r.to_port <= 65535 && r.to_port >= r.from_port))
        &&
        (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.security_group_ids) > 0)
      )
    ])
    error_message = "Cada regra de egress deve ter protocolo valido, portas coerentes (ou -1) e pelo menos um destino (cidr_blocks, ipv6_cidr_blocks ou security_group_ids)."
  }
}
