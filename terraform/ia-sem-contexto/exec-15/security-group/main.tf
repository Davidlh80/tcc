provider "aws" {
  region = var.region
}

locals {
  common_tags = merge(
    {
      ManagedBy = "Terraform"
    },
    var.tags,
    {
      Name = var.name
    }
  )
}

resource "aws_security_group" "this" {
  name                   = var.name
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true
  tags                   = local.common_tags
}

resource "aws_security_group_rule" "ingress" {
  for_each = {
    for idx, rule in var.ingress_rules : tostring(idx) => rule
  }

  type              = "ingress"
  security_group_id = aws_security_group.this.id

  description = coalesce(each.value.description, "Managed ingress")
  protocol    = lower(each.value.protocol)
  from_port   = each.value.from_port
  to_port     = each.value.to_port

  cidr_blocks       = coalesce(each.value.cidr_blocks, [])
  ipv6_cidr_blocks  = coalesce(each.value.ipv6_cidr_blocks, [])
  prefix_list_ids   = coalesce(each.value.prefix_list_ids, [])
  self              = coalesce(each.value.self, false)
}

resource "aws_security_group_rule" "egress" {
  for_each = {
    for idx, rule in var.egress_rules : tostring(idx) => rule
  }

  type              = "egress"
  security_group_id = aws_security_group.this.id

  description = coalesce(each.value.description, "Managed egress")
  protocol    = lower(each.value.protocol)
  from_port   = each.value.from_port
  to_port     = each.value.to_port

  cidr_blocks       = coalesce(each.value.cidr_blocks, [])
  ipv6_cidr_blocks  = coalesce(each.value.ipv6_cidr_blocks, [])
  prefix_list_ids   = coalesce(each.value.prefix_list_ids, [])
  self              = coalesce(each.value.self, false)
}
