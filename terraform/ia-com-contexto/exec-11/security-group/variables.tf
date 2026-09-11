variable "region" {
  description = "Região AWS onde os recursos serão provisionados."
  type        = string
  validation {
    condition     = length(trimspace(var.region)) > 0
    error_message = "A variável 'region' não pode ser vazia."
  }
}

variable "environment" {
  description = "Ambiente alvo (dev, hml, prd)."
  type        = string
  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome curto do sistema/produto (ex.: tcc)."
  type        = string
  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "A variável 'system' não pode ser vazia."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas às tags padrão. Chaves padrão não serão sobrescritas."
  type        = map(string)
  default     = {}
}

variable "security_group_name" {
  description = "Finalidade ou nome lógico do Security Group (usado na nomenclatura <env>-<sistema>-sg-<finalidade>)."
  type        = string
  validation {
    condition     = length(trimspace(var.security_group_name)) > 0
    error_message = "A variável 'security_group_name' não pode ser vazia."
  }
}

variable "security_group_description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Managed by Terraform"
  validation {
    condition     = length(trimspace(var.security_group_description)) > 0
    error_message = "A variável 'security_group_description' não pode ser vazia."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string
  validation {
    condition     = length(trimspace(var.vpc_id)) > 0 && can(regex("^vpc-[0-9a-fA-F]+$", var.vpc_id))
    error_message = "A variável 'vpc_id' deve ser um ID de VPC válido (ex.: vpc-xxxxxxxx)."
  }
}

variable "ingress_rules" {
  description = <<EOT
Lista de regras de entrada. Cada regra deve definir exatamente UMA origem entre: cidr_ipv4, cidr_ipv6, prefix_list_id, referenced_security_group_id ou self=true.
Restrições:
- Descrição obrigatória;
- from_port <= to_port;
- Proibido 0.0.0.0/0 (ou ::/0) em qualquer porta diferente de 443/tcp.
Exemplo de item:
{
  description = "HTTPS from Internet",
  protocol    = "tcp",
  from_port   = 443,
  to_port     = 443,
  cidr_ipv4   = "0.0.0.0/0"
}
EOT
  type = list(object({
    description                   = string
    protocol                      = string
    from_port                     = number
    to_port                       = number
    cidr_ipv4                     = optional(string)
    cidr_ipv6                     = optional(string)
    prefix_list_id                = optional(string)
    referenced_security_group_id  = optional(string)
    self                          = optional(bool, false)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      length(trimspace(r.description)) > 0 &&
      r.from_port <= r.to_port &&
      length(compact([
        try(r.cidr_ipv4, null),
        try(r.cidr_ipv6, null),
        try(r.prefix_list_id, null),
        try(r.referenced_security_group_id, null),
        (try(r.self, false) ? "self" : null)
      ])) == 1 &&
      (
        (try(r.cidr_ipv4, "") == "0.0.0.0/0" || try(r.cidr_ipv6, "") == "::/0")
        ? (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
        : true
      )
    ])
    error_message = "Ingress: cada regra deve ter descrição, from_port <= to_port, exatamente UMA origem definida, e '0.0.0.0/0' ou '::/0' só é permitido em tcp/443."
  }
}

variable "egress_rules" {
  description = <<EOT
Lista de regras de saída. Cada regra deve definir exatamente UM destino entre: cidr_ipv4, cidr_ipv6, prefix_list_id, referenced_security_group_id ou self=true.
Restrições:
- Descrição obrigatória;
- from_port <= to_port;
- Proibido 0.0.0.0/0 (ou ::/0) em qualquer porta diferente de 443/tcp.
EOT
  type = list(object({
    description                   = string
    protocol                      = string
    from_port                     = number
    to_port                       = number
    cidr_ipv4                     = optional(string)
    cidr_ipv6                     = optional(string)
    prefix_list_id                = optional(string)
    referenced_security_group_id  = optional(string)
    self                          = optional(bool, false)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      length(trimspace(r.description)) > 0 &&
      r.from_port <= r.to_port &&
      length(compact([
        try(r.cidr_ipv4, null),
        try(r.cidr_ipv6, null),
        try(r.prefix_list_id, null),
        try(r.referenced_security_group_id, null),
        (try(r.self, false) ? "self" : null)
      ])) == 1 &&
      (
        (try(r.cidr_ipv4, "") == "0.0.0.0/0" || try(r.cidr_ipv6, "") == "::/0")
        ? (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
        : true
      )
    ])
    error_message = "Egress: cada regra deve ter descrição, from_port <= to_port, exatamente UM destino definido, e '0.0.0.0/0' ou '::/0' só é permitido em tcp/443."
  }
}
