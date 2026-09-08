provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "this" {
  name                      = var.name != null ? var.name : null
  name_prefix               = var.name == null ? var.name_prefix : null
  description               = var.description
  vpc_id                    = var.vpc_id
  revoke_rules_on_delete    = var.revoke_rules_on_delete

  tags = merge(
    {
      Name      = var.name != null ? var.name : var.name_prefix
      ManagedBy = "Terraform"
    },
    var.tags
  )

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description      = try(ingress.value.description, null)
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = try(ingress.value.cidr_blocks, [])
      ipv6_cidr_blocks = try(ingress.value.ipv6_cidr_blocks, [])
      prefix_list_ids  = try(ingress.value.prefix_list_ids, [])
      security_groups  = try(ingress.value.security_groups, [])
      self             = try(ingress.value.self, false)
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description      = try(egress.value.description, null)
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      cidr_blocks      = try(egress.value.cidr_blocks, [])
      ipv6_cidr_blocks = try(egress.value.ipv6_cidr_blocks, [])
      prefix_list_ids  = try(egress.value.prefix_list_ids, [])
      security_groups  = try(egress.value.security_groups, [])
      self             = try(egress.value.self, false)
    }
  }
}
