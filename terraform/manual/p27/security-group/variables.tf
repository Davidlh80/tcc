variable "security_group_name" {
  description = "Nome-base do Security Group."
  type        = string

  validation {
    condition = (
      length(var.security_group_name) > 0 &&
      !strcontains(var.security_group_name, "/")
    )
    error_message = "Informe um nome nao vazio e sem barras."
  }
}

variable "vpc_id" {
  description = "ID da VPC de destino."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]+$", var.vpc_id))
    error_message = "Informe um ID de VPC valido."
  }
}

variable "environment" {
  description = "Ambiente de implantacao."
  type        = string

  validation {
    condition = contains(
      ["dev", "hml", "stg", "prod"],
      var.environment
    )
    error_message = "Use dev, hml, stg ou prod."
  }
}

variable "description" {
  description = "Finalidade do Security Group."
  type        = string
  default     = "Security Group gerenciado pelo Terraform"
}

variable "ingress_rules" {
  description = "Regras IPv4 explicitas de entrada."
  type = list(object({
    name        = string
    description = string
    protocol    = string
    from_port   = number
    to_port     = number
    cidr_ipv4   = string
  }))
  default = []

  validation {
    condition = (
      length(distinct([
        for rule in var.ingress_rules : rule.name
      ])) == length(var.ingress_rules) &&
      alltrue([
        for rule in var.ingress_rules :
        trimspace(rule.name) != "" &&
        trimspace(rule.description) != "" &&
        can(cidrnetmask(rule.cidr_ipv4)) &&
        contains(
          ["tcp", "udp", "icmp", "icmpv6", "-1"],
          rule.protocol
        ) &&
        (
          rule.protocol == "-1" ? (
            rule.from_port == 0 && rule.to_port == 0
          ) : contains(["tcp", "udp"], rule.protocol) ? (
            rule.from_port >= 0 &&
            rule.to_port >= rule.from_port &&
            rule.to_port <= 65535
          ) : (
            rule.from_port >= -1 &&
            rule.from_port <= 255 &&
            rule.to_port >= -1 &&
            rule.to_port <= 255
          )
        )
      ])
    )
    error_message = "Verifique nomes unicos, descricoes, CIDRs, protocolos e intervalos das regras de entrada."
  }
}

variable "egress_rules" {
  description = "Regras IPv4 explicitas de saida."
  type = list(object({
    name        = string
    description = string
    protocol    = string
    from_port   = number
    to_port     = number
    cidr_ipv4   = string
  }))
  default = []

  validation {
    condition = (
      length(distinct([
        for rule in var.egress_rules : rule.name
      ])) == length(var.egress_rules) &&
      alltrue([
        for rule in var.egress_rules :
        trimspace(rule.name) != "" &&
        trimspace(rule.description) != "" &&
        can(cidrnetmask(rule.cidr_ipv4)) &&
        contains(
          ["tcp", "udp", "icmp", "icmpv6", "-1"],
          rule.protocol
        ) &&
        (
          rule.protocol == "-1" ? (
            rule.from_port == 0 && rule.to_port == 0
          ) : contains(["tcp", "udp"], rule.protocol) ? (
            rule.from_port >= 0 &&
            rule.to_port >= rule.from_port &&
            rule.to_port <= 65535
          ) : (
            rule.from_port >= -1 &&
            rule.from_port <= 255 &&
            rule.to_port >= -1 &&
            rule.to_port <= 255
          )
        )
      ])
    )
    error_message = "Verifique nomes unicos, descricoes, CIDRs, protocolos e intervalos das regras de saida."
  }
}

variable "additional_tags" {
  description = "Tags adicionais sem sobrescrita das tags obrigatorias."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for key, value in var.additional_tags :
      trimspace(key) != "" &&
      trimspace(value) != "" &&
      !contains(
        ["Environment", "ManagedBy", "Component"],
        key
      )
    ])
    error_message = "Tags vazias ou tentativa de sobrescrever tags obrigatorias."
  }
}
