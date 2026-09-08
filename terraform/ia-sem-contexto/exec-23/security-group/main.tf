provider "aws" {
  region = var.region
}

locals {
  default_tags = {
    ManagedBy = "Terraform"
  }

  tags = merge(local.default_tags, var.tags, {
    Name = var.name
  })
}

resource "aws_security_group" "this" {
  name                   = var.name
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description     = coalesce(ingress.value.description, "Regra gerenciada pelo Terraform")
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      cidr_blocks     = coalesce(ingress.value.cidr_blocks, [])
      ipv6_cidr_blocks = coalesce(ingress.value.ipv6_cidr_blocks, [])
      security_groups = coalesce(ingress.value.security_groups, [])
      prefix_list_ids = coalesce(ingress.value.prefix_list_ids, [])
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules == null ? [] : var.egress_rules
    content {
      description     = coalesce(egress.value.description, "Regra gerenciada pelo Terraform")
      from_port       = egress.value.from_port
      to_port         = egress.value.to_port
      protocol        = egress.value.protocol
      cidr_blocks     = coalesce(egress.value.cidr_blocks, [])
      ipv6_cidr_blocks = coalesce(egress.value.ipv6_cidr_blocks, [])
      security_groups = coalesce(egress.value.security_groups, [])
      prefix_list_ids = coalesce(egress.value.prefix_list_ids, [])
    }
  }

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}
