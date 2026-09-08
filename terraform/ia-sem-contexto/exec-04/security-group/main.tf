provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "this" {
  name                   = var.sg_name
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = coalesce(ingress.value.description, "managed-ingress")
      from_port   = ingress.value.protocol == "-1" ? 0 : ingress.value.from_port
      to_port     = ingress.value.protocol == "-1" ? 0 : ingress.value.to_port
      protocol    = ingress.value.protocol

      cidr_blocks      = length(ingress.value.cidr_blocks) > 0 ? ingress.value.cidr_blocks : null
      ipv6_cidr_blocks = length(ingress.value.ipv6_cidr_blocks) > 0 ? ingress.value.ipv6_cidr_blocks : null
      security_groups  = length(ingress.value.security_group_ids) > 0 ? ingress.value.security_group_ids : null
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description = coalesce(egress.value.description, "managed-egress")
      from_port   = egress.value.protocol == "-1" ? 0 : egress.value.from_port
      to_port     = egress.value.protocol == "-1" ? 0 : egress.value.to_port
      protocol    = egress.value.protocol

      cidr_blocks      = length(egress.value.cidr_blocks) > 0 ? egress.value.cidr_blocks : null
      ipv6_cidr_blocks = length(egress.value.ipv6_cidr_blocks) > 0 ? egress.value.ipv6_cidr_blocks : null
      security_groups  = length(egress.value.security_group_ids) > 0 ? egress.value.security_group_ids : null
    }
  }

  tags = merge(
    {
      Name = var.sg_name
    },
    var.tags
  )
}
