variable "region" {
  description = "Região AWS onde o Security Group será criado (ex.: us-east-1)."
  type        = string
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "A variável region deve estar no formato válido de região AWS, por exemplo: us-east-1."
  }
}

variable "environment" {
  description = "Ambiente alvo: dev, hml ou prd."
  type        = string
  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema/aplicação (minúsculas, números e hífens)."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas minúsculas, números e hífens."
  }
}

variable "security_group_name" {
  description = "Finalidade/nome específico do Security Group (minúsculas, números e hífens). Será usado no padrão <environment>-<system>-sg-<security_group_name>."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.security_group_name)) && length(var.security_group_name) > 0
    error_message = "security_group_name deve conter apenas minúsculas, números e hífens."
  }
}

variable "security_group_description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado por Terraform."
  validation {
    condition     = length(trimspace(var.security_group_description)) > 0
    error_message = "security_group_description não pode ser vazio."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string
  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]+$", var.vpc_id))
    error_message = "vpc_id deve ser um ID de VPC válido (ex.: vpc-0123456789abcdef0)."
  }
}

variable "ingress_rules" {
  description = <<EOT
Lista de regras de entrada. Cada item:
{
  description        = string (obrigatório)
  protocol           = string (ex.: "tcp", "udp", "-1")
  from_port          = number
  to_port            = number
  cidr_blocks        = optional(list(string), [])
  ipv6_cidr_blocks   = optional(list(string), [])
  security_groups    = optional(list(string), [])
  self               = optional(bool, false)
}
Restrições:
- 0.0.0.0/0 (e ::/0) só é permitido para TCP porta 443 (from_port == 443 e to_port == 443).
- Toda regra deve ter descrição não vazia.
- from_port deve ser <= to_port.
EOT
  type = list(object({
    description      = string
    protocol         = string
    from_port        = number
    to_port          = number
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
    security_groups  = optional(list(string), [])
    self             = optional(bool, false)
  }))
  default = []

  validation {
    condition = length([
      for r in var.ingress_rules : 1
      if length(trimspace(r.description)) > 0
        && r.from_port <= r.to_port
        && (
          !(
            contains(try(r.cidr_blocks, []), "0.0.0.0/0")
            || contains(try(r.ipv6_cidr_blocks, []), "::/0")
          )
          || (
            lower(r.protocol) == "tcp"
            && r.from_port == 443
            && r.to_port == 443
          )
        )
    ]) == length(var.ingress_rules)
    error_message = "Regras de ingress: descrição obrigatória, from_port <= to_port e 0.0.0.0/0 (ou ::/0) apenas TCP porta 443 com from_port=to_port=443."
  }
}

variable "egress_rules" {
  description = <<EOT
Lista de regras de saída. Cada item:
{
  description        = string (obrigatório)
  protocol           = string (ex.: "tcp", "udp", "-1")
  from_port          = number
  to_port            = number
  cidr_blocks        = optional(list(string), [])
  ipv6_cidr_blocks   = optional(list(string), [])
  security_groups    = optional(list(string), [])
  self               = optional(bool, false)
}
Padrão seguro: libera apenas HTTPS (443/tcp) para Internet (IPv4 e IPv6).
Restrições:
- 0.0.0.0/0 (e ::/0) só é permitido para TCP porta 443 (from_port == 443 e to_port == 443).
- Toda regra deve ter descrição não vazia.
- from_port deve ser <= to_port.
EOT
  type = list(object({
    description      = string
    protocol         = string
    from_port        = number
    to_port          = number
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
    security_groups  = optional(list(string), [])
    self             = optional(bool, false)
  }))
  default = [
    {
      description      = "Allow HTTPS egress to Internet (IPv4 and IPv6)"
      protocol         = "tcp"
      from_port        = 443
      to_port          = 443
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = []
      self             = false
    }
  ]

  validation {
    condition = length([
      for r in var.egress_rules : 1
      if length(trimspace(r.description)) > 0
        && r.from_port <= r.to_port
        && (
          !(
            contains(try(r.cidr_blocks, []), "0.0.0.0/0")
            || contains(try(r.ipv6_cidr_blocks, []), "::/0")
          )
          || (
            lower(r.protocol) == "tcp"
            && r.from_port == 443
            && r.to_port == 443
          )
        )
    ]) == length(var.egress_rules)
    error_message = "Regras de egress: descrição obrigatória, from_port <= to_port e 0.0.0.0/0 (ou ::/0) apenas TCP porta 443 com from_port=to_port=443."
  }
}

variable "additional_tags" {
  description = "Mapa de tags adicionais a aplicar aos recursos. As tags obrigatórias são sempre aplicadas."
  type        = map(string)
  default     = {}
}
