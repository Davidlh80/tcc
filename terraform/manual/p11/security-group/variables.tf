variable "environment" {
  description = "Ambiente de implantacao."
  type        = string
  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "Use dev, hml ou prd."
  }
}

variable "system" {
  description = "Identificacao do sistema."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.system))
    error_message = "Use letras minusculas, numeros e hifens entre segmentos."
  }
}

variable "region" {
  description = "Regiao AWS."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais; tags obrigatorias prevalecem."
  type        = map(string)
  default     = {}
}

variable "security_group_name" {
  description = "Finalidade que compoe o nome do grupo."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.security_group_name))
    error_message = "Use letras minusculas, numeros e hifens entre segmentos."
  }
}

variable "vpc_id" {
  description = "ID da VPC existente."
  type        = string
  validation {
    condition     = can(regex("^vpc-([0-9a-f]{8}|[0-9a-f]{17})$", var.vpc_id))
    error_message = "Informe um ID de VPC valido."
  }
}

variable "ingress_rules" {
  description = "Regras explicitas de ingress, com chaves estaveis."
  type = map(object({
    description = string
    ip_protocol = string
    from_port   = number
    to_port     = number
    cidr_ipv4   = string
  }))
  default = {}
  validation {
    condition = alltrue([for rule in var.ingress_rules :
      length(trimspace(rule.description)) > 0 &&
      contains(["tcp", "udp"], rule.ip_protocol) &&
      rule.from_port >= 0 && rule.to_port <= 65535 &&
      floor(rule.from_port) == rule.from_port && floor(rule.to_port) == rule.to_port &&
      rule.from_port <= rule.to_port &&
      can(cidrnetmask(rule.cidr_ipv4)) &&
      (try(cidrnetmask(rule.cidr_ipv4), "") != "0.0.0.0" ||
        (rule.ip_protocol == "tcp" && rule.from_port == 443 && rule.to_port == 443))
    ])
    error_message = "Use descricao, CIDR IPv4 e portas inteiras validas TCP/UDP; /0 somente em 443/tcp."
  }
}

variable "egress_rules" {
  description = "Regras explicitas de egress, com chaves estaveis."
  type = map(object({
    description = string
    ip_protocol = string
    from_port   = number
    to_port     = number
    cidr_ipv4   = string
  }))
  default = {}
  validation {
    condition = alltrue([for rule in var.egress_rules :
      length(trimspace(rule.description)) > 0 &&
      contains(["tcp", "udp"], rule.ip_protocol) &&
      rule.from_port >= 0 && rule.to_port <= 65535 &&
      floor(rule.from_port) == rule.from_port && floor(rule.to_port) == rule.to_port &&
      rule.from_port <= rule.to_port &&
      can(cidrnetmask(rule.cidr_ipv4)) &&
      (try(cidrnetmask(rule.cidr_ipv4), "") != "0.0.0.0" ||
        (rule.ip_protocol == "tcp" && rule.from_port == 443 && rule.to_port == 443))
    ])
    error_message = "Use descricao, CIDR IPv4 e portas inteiras validas TCP/UDP; /0 somente em 443/tcp."
  }
}
