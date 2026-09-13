variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-f0-9]+$", var.vpc_id))
    error_message = "O valor de vpc_id deve ser um ID de VPC valido, no formato vpc-xxxxxxxx."
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
  default     = "Security group gerenciado via Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress) do Security Group."
  type = list(object({
    description = optional(string, "")
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.ingress_rules : r.from_port <= r.to_port])
    error_message = "Em cada regra de ingress_rules, from_port deve ser menor ou igual a to_port."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      r.from_port >= -1 && r.from_port <= 65535 && r.to_port >= -1 && r.to_port <= 65535
    ])
    error_message = "As portas em ingress_rules devem estar entre -1 (todas/ICMP) e 65535."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      !contains(r.cidr_blocks, "0.0.0.0/0") || (
        (r.from_port > 22 || r.to_port < 22) &&
        (r.from_port > 3389 || r.to_port < 3389)
      )
    ])
    error_message = "Nao e permitido liberar as portas 22 (SSH) ou 3389 (RDP) para 0.0.0.0/0 em ingress_rules."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida (egress) do Security Group. Se vazia, nenhum trafego de saida sera permitido."
  type = list(object({
    description = optional(string, "")
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.egress_rules : r.from_port <= r.to_port])
    error_message = "Em cada regra de egress_rules, from_port deve ser menor ou igual a to_port."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      r.from_port >= -1 && r.from_port <= 65535 && r.to_port >= -1 && r.to_port <= 65535
    ])
    error_message = "As portas em egress_rules devem estar entre -1 (todas/ICMP) e 65535."
  }
}

variable "tags" {
  description = "Tags adicionais para o Security Group."
  type        = map(string)
  default     = {}
}
