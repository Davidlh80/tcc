locals {
  # Tags padrao para todos os recursos deste template
  default_tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
    }
  )
}

provider "aws" {
  region = var.region

  default_tags {
    tags = local.default_tags
  }
}

resource "aws_security_group" "this" {
  name                   = var.name
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete

  # Regras de entrada (ingress)
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description      = try(ingress.value.description, null)
      from_port        = try(ingress.value.from_port, 0)
      to_port          = try(ingress.value.to_port, 0)
      protocol         = try(ingress.value.protocol, "-1")
      cidr_blocks      = try(ingress.value.cidr_blocks, [])
      ipv6_cidr_blocks = try(ingress.value.ipv6_cidr_blocks, [])
      prefix_list_ids  = try(ingress.value.prefix_list_ids, [])
      security_groups  = try(ingress.value.security_groups, [])
      self             = try(ingress.value.self, false)
    }
  }

  # Regras de saida (egress)
  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description      = try(egress.value.description, null)
      from_port        = try(egress.value.from_port, 0)
      to_port          = try(egress.value.to_port, 0)
      protocol         = try(egress.value.protocol, "-1")
      cidr_blocks      = try(egress.value.cidr_blocks, [])
      ipv6_cidr_blocks = try(egress.value.ipv6_cidr_blocks, [])
      prefix_list_ids  = try(egress.value.prefix_list_ids, [])
      security_groups  = try(egress.value.security_groups, [])
      self             = try(egress.value.self, false)
    }
  }

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}
