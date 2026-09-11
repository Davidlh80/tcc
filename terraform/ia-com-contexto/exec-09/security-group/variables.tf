variable "region" {
  description = "Região AWS onde os recursos serão provisionados."
  type        = string
  nullable    = false
}

variable "environment" {
  description = "Ambiente de implantação: dev, hml ou prd."
  type        = string
  nullable    = false
  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    message       = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/produto (ex.: tcc)."
  type        = string
  nullable    = false
  validation {
    condition     = can(regex("^[a-z0-9-]{2,32}$", var.system))
    message       = "system deve conter apenas letras minúsculas, números e hífen (2-32 caracteres)."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas em todos os recursos."
  type        = map(string)
  default     = {}
  validation {
    condition = length([
      for k, _ in var.additional_tags :
      k if contains(["Project", "Environment", "ManagedBy", "Owner", "CostCenter"], k)
    ]) == 0
    message = "additional_tags não pode sobrescrever as tags obrigatórias: Project, Environment, ManagedBy, Owner, CostCenter."
  }
}

variable "security_group_name" {
  description = "Finalidade do Security Group (comporá o nome conforme padrão: <env>-<system>-sg-<security_group_name>)."
  type        = string
  nullable    = false
  validation {
    condition     = can(regex("^[a-z0-9-]{2,32}$", var.security_group_name))
    message       = "security_group_name deve conter apenas letras minúsculas, números e hífen (2-32 caracteres)."
  }
}

variable "security_group_description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado por Terraform"
  validation {
    condition     = length(trim(var.security_group_description)) > 0
    message       = "security_group_description não pode ser vazio."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string
  nullable    = false
  validation {
    condition     = can(regex("^vpc-[0-9a-f]{8,}$", var.vpc_id))
    message       = "vpc_id deve corresponder ao formato de ID de VPC (ex.: vpc-xxxxxxxx)."
  }
}

variable "ingress_rules" {
  description = <<EOT
Lista de regras de entrada (ingress). Cada item deve conter:
- description (string, obrigatório)
- from_port (number, obrigatório)
- to_port (number, obrigatório)
- protocol (string, obrigatório; ex.: tcp, udp, icmp, -1)
- cidr_blocks (lista de strings, obrigatório)
- ipv6_cidr_blocks (lista de strings, obrigatório)
- security_groups (lista de strings, obrigatório)
- prefix_list_ids (lista de strings, obrigatório)

Observações de segurança:
- É proibido 0.0.0.0/0 (e ::/0) em qualquer porta que não seja exatamente 443/tcp.
- Toda regra deve possuir description não vazia.
EOT
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    security_groups  = list(string)
    prefix_list_ids  = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      length(trim(r.description)) > 0
    ])
    message = "Todas as regras de ingress devem ter description não vazia."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      r.from_port <= r.to_port
    ])
    message = "Em todas as regras de ingress, from_port deve ser menor ou igual a to_port."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      alltrue([
        for c in r.cidr_blocks :
        c != "0.0.0.0/0" || (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      ]) && alltrue([
        for c6 in r.ipv6_cidr_blocks :
        c6 != "::/0" || (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      ])
    ])
    message = "Regras de ingress com 0.0.0.0/0 ou ::/0 só são permitidas exatamente para 443/tcp."
  }
}

variable "egress_rules" {
  description = <<EOT
Lista de regras de saída (egress). Deve ser declarada explicitamente (sem liberação irrestrita por padrão). Cada item deve conter:
- description (string, obrigatório)
- from_port (number, obrigatório)
- to_port (number, obrigatório)
- protocol (string, obrigatório; ex.: tcp, udp, icmp, -1)
- cidr_blocks (lista de strings, obrigatório)
- ipv6_cidr_blocks (lista de strings, obrigatório)
- security_groups (lista de strings, obrigatório)
- prefix_list_ids (lista de strings, obrigatório)

Observações de segurança:
- É proibido 0.0.0.0/0 (e ::/0) em qualquer porta que não seja exatamente 443/tcp.
- Toda regra deve possuir description não vazia.
- Por padrão, permanece vazio para evitar egress irrestrito.
EOT
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    security_groups  = list(string)
    prefix_list_ids  = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      length(trim(r.description)) > 0
    ])
    message = "Todas as regras de egress devem ter description não vazia."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      r.from_port <= r.to_port
    ])
    message = "Em todas as regras de egress, from_port deve ser menor ou igual a to_port."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      alltrue([
        for c in r.cidr_blocks :
        c != "0.0.0.0/0" || (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      ]) && alltrue([
        for c6 in r.ipv6_cidr_blocks :
        c6 != "::/0" || (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      ])
    ])
    message = "Regras de egress com 0.0.0.0/0 ou ::/0 só são permitidas exatamente para 443/tcp."
  }
}
