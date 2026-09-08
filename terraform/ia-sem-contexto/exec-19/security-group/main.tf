provider "aws" {
  region = var.region
}

locals {
  tags = merge(
    {
      Name = var.sg_name
    },
    var.tags
  )
}

resource "aws_security_group" "this" {
  name                   = var.sg_name
  description            = var.sg_description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete

  tags = local.tags
}

resource "aws_security_group_rule" "ingress" {
  for_each = {
    for idx, rule in var.ingress_rules :
    format("ingress-%03d", idx) => rule
  }

  type              = "ingress"
  security_group_id = aws_security_group.this.id

  description = each.value.description
  from_port   = each.value.protocol == "-1" ? 0 : each.value.from_port
  to_port     = each.value.protocol == "-1" ? 0 : each.value.to_port
  protocol    = each.value.protocol

  cidr_blocks              = length(each.value.cidr_blocks) > 0 ? each.value.cidr_blocks : null
  ipv6_cidr_blocks         = length(each.value.ipv6_cidr_blocks) > 0 ? each.value.ipv6_cidr_blocks : null
  prefix_list_ids          = length(each.value.prefix_list_ids) > 0 ? each.value.prefix_list_ids : null
  source_security_group_id = length(each.value.source_security_group_id) > 0 ? each.value.source_security_group_id : null
}

resource "aws_security_group_rule" "egress" {
  for_each = {
    for idx, rule in var.egress_rules :
    format("egress-%03d", idx) => rule
  }

  type              = "egress"
  security_group_id = aws_security_group.this.id

  description = each.value.description
  from_port   = each.value.protocol == "-1" ? 0 : each.value.from_port
  to_port     = each.value.protocol == "-1" ? 0 : each.value.to_port
  protocol    = each.value.protocol

  cidr_blocks                   = length(each.value.cidr_blocks) > 0 ? each.value.cidr_blocks : null
  ipv6_cidr_blocks              = length(each.value.ipv6_cidr_blocks) > 0 ? each.value.ipv6_cidr_blocks : null
  prefix_list_ids               = length(each.value.prefix_list_ids) > 0 ? each.value.prefix_list_ids : null
  destination_security_group_id = length(each.value.destination_security_group_id) > 0 ? each.value.destination_security_group_id : null
}
