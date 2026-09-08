provider "aws" {
  region = var.region

  default_tags {
    tags = {
      ManagedBy = "Terraform"
    }
  }
}

resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  revoke_rules_on_delete = true

  dynamic "Ingress" {
    for_each = {}
    content {}
  }

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description      = coalesce(ingress.value.description, "")
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = coalesce(ingress.value.cidr_blocks, [])
      ipv6_cidr_blocks = coalesce(ingress.value.ipv6_cidr_blocks, [])
      security_groups  = coalesce(ingress.value.security_groups, [])
      self             = coalesce(ingress.value.self, false)
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description      = coalesce(egress.value.description, "")
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      cidr_blocks      = coalesce(egress.value.cidr_blocks, [])
      ipv6_cidr_blocks = coalesce(egress.value.ipv6_cidr_blocks, [])
      security_groups  = coalesce(egress.value.security_groups, [])
      self             = coalesce(egress.value.self, false)
    }
  }

  tags = merge(var.tags, {
    Name = var.name
  })
}
