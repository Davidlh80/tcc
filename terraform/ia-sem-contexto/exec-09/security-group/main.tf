provider "aws" {
  region = var.aws_region
}

locals {
  tags = merge(var.tags, {
    Name      = var.name
    ManagedBy = "Terraform"
  })
}

resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  revoke_rules_on_delete = true

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description      = try(ingress.value.description, null)
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = lower(ingress.value.protocol)
      cidr_blocks      = try(ingress.value.cidr_blocks, [])
      ipv6_cidr_blocks = try(ingress.value.ipv6_cidr_blocks, [])
      prefix_list_ids  = try(ingress.value.prefix_list_ids, [])
      self             = try(ingress.value.self, false)
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description      = try(egress.value.description, null)
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = lower(egress.value.protocol)
      cidr_blocks      = try(egress.value.cidr_blocks, [])
      ipv6_cidr_blocks = try(egress.value.ipv6_cidr_blocks, [])
      prefix_list_ids  = try(egress.value.prefix_list_ids, [])
      self             = try(egress.value.self, false)
    }
  }

  tags = local.tags
}
