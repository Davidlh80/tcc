provider "aws" {
  region = var.region
}

locals {
  default_tags = {
    ManagedBy = "Terraform"
  }

  tags = merge(local.default_tags, var.tags, { Name = var.name })
}

resource "aws_security_group" "this" {
  name                   = var.name
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description      = ingress.value.description
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = lower(ingress.value.protocol) == "-1" ? "-1" : lower(ingress.value.protocol)
      cidr_blocks      = ingress.value.cidr_blocks
      ipv6_cidr_blocks = ingress.value.ipv6_cidr_blocks
      security_groups  = ingress.value.security_group_ids
      self             = ingress.value.self
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description      = egress.value.description
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = lower(egress.value.protocol) == "-1" ? "-1" : lower(egress.value.protocol)
      cidr_blocks      = egress.value.cidr_blocks
      ipv6_cidr_blocks = egress.value.ipv6_cidr_blocks
      security_groups  = egress.value.security_group_ids
      self             = egress.value.self
    }
  }

  tags = local.tags
}
