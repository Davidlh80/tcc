variable "environment" {
  description = "Ambiente do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml ou prd."
  }
}

variable "system" {
  description = "Nome do sistema/aplicação (minúsculas, números e hifens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas letras minúsculas, números e hifens."
  }
}

variable "region" {
  description = "Região AWS onde o Security Group será criado (ex: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "region deve corresponder ao padrão de regiões AWS, ex.: us-east-1."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas às tags obrigatórias."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]+$", var.vpc_id))
    error_message = "vpc_id deve iniciar com 'vpc-' seguido de caracteres hexadecimais."
  }
}

variable "security_group_name" {
  description = "Finalidade do Security Group (usado no padrão <env>-<sistema>-sg-<finalidade>)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.security_group_name)) && length(var.security_group_name) > 0
    error_message = "security_group_name deve conter apenas letras minúsculas, números e hifens."
  }
}

variable "security_group_description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado por Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada. Cada item deve conter description, protocol, from_port, to_port, cidr_blocks e ipv6_cidr_blocks."
  type = list(object({
    description       = string
    protocol          = string
    from_port         = number
    to_port           = number
    cidr_blocks       = list(string)
    ipv6_cidr_blocks  = list(string)
  }))
  default = []

  # Descrição obrigatória
  validation {
    condition     = alltrue([for r in var.ingress_rules : length(trim(r.description)) > 0])
    error_message = "Todas as regras de entrada devem conter uma descrição não vazia."
  }

  # Portas válidas e coerentes
  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      r.from_port >= 0 && r.from_port <= 65535 && r.to_port >= 0 && r.to_port <= 65535 && r.from_port <= r.to_port
    ])
    error_message = "Todas as regras de entrada devem possuir portas válidas (0-65535) e from_port <= to_port."
  }

  # Ao menos um destino por regra
  validation {
    condition     = alltrue([for r in var.ingress_rules : (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks)) > 0])
    error_message = "Cada regra de entrada deve especificar ao menos um bloco CIDR (IPv4 ou IPv6)."
  }

  # Proibir 0.0.0.0/0 ou ::/0 exceto 443/tcp
  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (
        !(contains(r.cidr_blocks, "0.0.0.0/0") || contains(r.ipv6_cidr_blocks, "::/0"))
        ||
        (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      )
    ])
    error_message = "Em regras de entrada, 0.0.0.0/0 ou ::/0 só são permitidos para 443/tcp."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída. Cada item deve conter description, protocol, from_port, to_port, cidr_blocks e ipv6_cidr_blocks. Padrão permite apenas HTTPS (443/tcp) para Internet."
  type = list(object({
    description       = string
    protocol          = string
    from_port         = number
    to_port           = number
    cidr_blocks       = list(string)
    ipv6_cidr_blocks  = list(string)
  }))

  # Padrão seguro e explícito: apenas HTTPS para IPv4; nenhum IPv6 por padrão.
  default = [
    {
      description      = "default-https-egress"
      protocol         = "tcp"
      from_port        = 443
      to_port          = 443
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
    }
  ]

  # Descrição obrigatória
  validation {
    condition     = alltrue([for r in var.egress_rules : length(trim(r.description)) > 0])
    error_message = "Todas as regras de saída devem conter uma descrição não vazia."
  }

  # Portas válidas e coerentes
  validation {
    condition = alltrue([
      for r in var.egress_rules :
      r.from_port >= 0 && r.from_port <= 65535 && r.to_port >= 0 && r.to_port <= 65535 && r.from_port <= r.to_port
    ])
    error_message = "Todas as regras de saída devem possuir portas válidas (0-65535) e from_port <= to_port."
  }

  # Ao menos um destino por regra
  validation {
    condition     = alltrue([for r in var.egress_rules : (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks)) > 0])
    error_message = "Cada regra de saída deve especificar ao menos um bloco CIDR (IPv4 ou IPv6)."
  }

  # Proibir 0.0.0.0/0 ou ::/0 exceto 443/tcp
  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (
        !(contains(r.cidr_blocks, "0.0.0.0/0") || contains(r.ipv6_cidr_blocks, "::/0"))
        ||
        (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      )
    ])
    error_message = "Em regras de saída, 0.0.0.0/0 ou ::/0 só são permitidos para 443/tcp."
  }
}
