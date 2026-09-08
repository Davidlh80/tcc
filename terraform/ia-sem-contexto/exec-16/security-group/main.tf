provider "aws" {
  region = var.region
}

locals {
  effective_tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
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
      protocol         = ingress.value.protocol
      cidr_blocks      = try(ingress.value.cidr_blocks, null)
      ipv6_cidr_blocks = try(ingress.value.ipv6_cidr_blocks, null)
      prefix_list_ids  = try(ingress.value.prefix_list_ids, null)
      security_groups  = try(ingress.value.source_security_group_id, null) != null && ingress.value.source_security_group_id != "" ? [ingress.value.source_security_group_id] : null
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description      = try(egress.value.description, null)
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      cidr_blocks      = try(egress.value.cidr_blocks, null)
      ipv6_cidr_blocks = try(egress.value.ipv6_cidr_blocks, null)
      prefix_list_ids  = try(egress.value.prefix_list_ids, null)
      security_groups  = try(egress.value.source_security_group_id, null) != null && egress.value.source_security_group_id != "" ? [egress.value.source_security_group_id] : null
    }
  }

  tags = local.effective_tags

  lifecycle {
    create_before_destroy = true
  }
}
