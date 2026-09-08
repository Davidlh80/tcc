locals {
  computed_ingress = [
    for r in var.ingress_rules : {
      description      = try(trimspace(r.description), null) != null ? trimspace(r.description) : "ingress"
      from_port        = r.from_port
      to_port          = r.to_port
      protocol         = lower(r.protocol)
      cidr_blocks      = try(r.cidr_blocks, [])
      ipv6_cidr_blocks = try(r.ipv6_cidr_blocks, [])
      security_groups  = try(r.security_groups, [])
      prefix_list_ids  = try(r.prefix_list_ids, []) // not used in ingress block, kept for schema symmetry
      self             = try(r.self, false)
    }
  ]

  computed_egress = [
    for r in var.egress_rules : {
      description      = try(trimspace(r.description), null) != null ? trimspace(r.description) : "egress"
      from_port        = r.from_port
      to_port          = r.to_port
      protocol         = lower(r.protocol)
      cidr_blocks      = try(r.cidr_blocks, [])
      ipv6_cidr_blocks = try(r.ipv6_cidr_blocks, [])
      security_groups  = try(r.security_groups, [])
      prefix_list_ids  = try(r.prefix_list_ids, [])
      self             = try(r.self, false) // not used in egress block, kept for input compatibility
    }
  ]

  // Filtra regras sem nenhuma origem/destino definido
  filtered_ingress = [
    for r in local.computed_ingress :
    r
    if length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.security_groups) + (r.self ? 1 : 0) > 0
  ]

  filtered_egress = [
    for r in local.computed_egress :
    r
    if length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.security_groups) + length(r.prefix_list_ids) > 0
  ]
}

resource "aws_security_group" "this" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id

  // Boa prática para limpeza de regras "inline"
  revoke_rules_on_delete = true

  // Ingress rules
  dynamic "ingress" {
    for_each = local.filtered_ingress
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol

      cidr_blocks      = ingress.value.cidr_blocks
      ipv6_cidr_blocks = ingress.value.ipv6_cidr_blocks
      security_groups  = ingress.value.security_groups
      self             = ingress.value.self
    }
  }

  // Egress rules
  dynamic "egress" {
    for_each = local.filtered_egress
    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol

      cidr_blocks      = egress.value.cidr_blocks
      ipv6_cidr_blocks = egress.value.ipv6_cidr_blocks
      security_groups  = egress.value.security_groups
      prefix_list_ids  = egress.value.prefix_list_ids
    }
  }

  tags = merge(
    {
      Name      = var.sg_name
      ManagedBy = "Terraform"
    },
    var.tags
  )
}
