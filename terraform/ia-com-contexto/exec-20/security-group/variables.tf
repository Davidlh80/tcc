variable "environment" {
  description = "Ambiente alvo. Deve ser um dos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um de: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/aplicação (minúsculas, números e hífens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS para o provider."
  type        = string

  validation {
    condition     = length(var.region) > 0
    error_message = "region não pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas ao recurso. Em caso de conflito, as tags obrigatórias prevalecem."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k in keys(var.additional_tags) :
      !contains(["Project", "Environment", "ManagedBy", "Owner", "CostCenter"], k)
    ])
    error_message = "additional_tags não pode sobrescrever as tags obrigatórias: Project, Environment, ManagedBy, Owner, CostCenter."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]+$", var.vpc_id))
    error_message = "vpc_id deve estar no formato válido (ex.: vpc-xxxxxxxx)."
  }
}

variable "security_group_name" {
  description = "Finalidade/nome do Security Group (minúsculas, números e hífens). Será usado no padrão <environment>-<system>-sg-<security_group_name>."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.security_group_name)) && length(var.security_group_name) > 0
    error_message = "security_group_name deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "security_group_description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado por Terraform"

  validation {
    condition     = length(var.security_group_description) > 0
    error_message = "security_group_description não pode ser vazio."
  }
}

variable "ingress_rules" {
  description = <<EOT
Lista de regras de entrada. Cada item deve conter:
- description (string, obrigatório)
- protocol (string, ex.: tcp, udp, icmp, -1)
- from_port (number)
- to_port (number)
- cidr_blocks (lista de strings, opcional)
- ipv6_cidr_blocks (lista de strings, opcional)

Restrições:
- É obrigatório informar ao menos um destino (cidr_blocks ou ipv6_cidr_blocks).
- 0.0.0.0/0 ou ::/0 só são permitidos em porta 443/tcp.
- Toda regra deve ter descrição.
- Portas devem ser válidas (0-65535) ou protocolo -1 com from/to = 0.
EOT
  type = list(object({
    description       = string
    protocol          = string
    from_port         = number
    to_port           = number
    cidr_blocks       = optional(list(string), [])
    ipv6_cidr_blocks  = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules : length(r.description) > 0
    ])
    error_message = "Todas as regras de ingress devem ter 'description' preenchida."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (
        (length(try(r.cidr_blocks, [])) + length(try(r.ipv6_cidr_blocks, []))) > 0
      )
    ])
    error_message = "Cada regra de ingress deve informar ao menos um destino (cidr_blocks ou ipv6_cidr_blocks)."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (
        (r.protocol == "-1" && r.from_port == 0 && r.to_port == 0)
        ||
        (r.from_port >= 0 && r.to_port <= 65535 && r.from_port <= r.to_port)
      )
    ])
    error_message = "Em ingress, portas devem estar no intervalo válido (0-65535) ou usar protocolo '-1' com from/to = 0."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (
        (!contains(try(r.cidr_blocks, []), "0.0.0.0/0") && !contains(try(r.ipv6_cidr_blocks, []), "::/0"))
        ||
        (r.protocol == "tcp" && r.from_port == 443 && r.to_port == 443)
      )
    ])
    error_message = "Em ingress, 0.0.0.0/0 ou ::/0 só são permitidos para 443/tcp."
  }
}

variable "egress_rules" {
  description = <<EOT
Lista de regras de saída. Cada item deve conter:
- description (string, obrigatório)
- protocol (string, ex.: tcp, udp, icmp, -1)
- from_port (number)
- to_port (number)
- cidr_blocks (lista de strings, opcional)
- ipv6_cidr_blocks (lista de strings, opcional)

Restrições:
- É obrigatório informar ao menos um destino (cidr_blocks ou ipv6_cidr_blocks).
- Toda regra deve ter descrição.
- Portas devem ser válidas (0-65535) ou protocolo -1 com from/to = 0.
Obs.: Egress é explícito. Por padrão nenhuma saída é liberada.
EOT
  type = list(object({
    description       = string
    protocol          = string
    from_port         = number
    to_port           = number
    cidr_blocks       = optional(list(string), [])
    ipv6_cidr_blocks  = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.egress_rules : length(r.description) > 0
    ])
    error_message = "Todas as regras de egress devem ter 'description' preenchida."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (
        (length(try(r.cidr_blocks, [])) + length(try(r.ipv6_cidr_blocks, []))) > 0
      )
    ])
    error_message = "Cada regra de egress deve informar ao menos um destino (cidr_blocks ou ipv6_cidr_blocks)."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (
        (r.protocol == "-1" && r.from_port == 0 && r.to_port == 0)
        ||
        (r.from_port >= 0 && r.to_port <= 65535 && r.from_port <= r.to_port)
      )
    ])
    error_message = "Em egress, portas devem estar no intervalo válido (0-65535) ou usar protocolo '-1' com from/to = 0."
  }
}
