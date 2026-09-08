provider "aws" {
  region = var.aws_region
}

locals {
  name_tag = var.enable_name_tag ? { Name = var.name } : {}
  tags     = merge(var.tags, local.name_tag)

  ingress_rules_by_key = {
    for idx, r in var.ingress_rules :
    format("%03d-%s-%d-%d", idx, lower(r.protocol), r.from_port, r.to_port) => r
  }

  egress_rules_by_key = {
    for idx, r in var.egress_rules :
    format("%03d-%s-%d-%d", idx, lower(r.protocol), r.from_port, r.to_port) => r
  }
}

resource "aws_security_group" "this" {
  name                   = var.name
  description            = var.sg_description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  # Secure by default: deny all egress.
  # Explicit rules can be added through aws_security_group_rule resources below.
  egress = []

  tags = local.tags

  lifecycle {
    # Prevent accidental replacement due to tag drift or description change
    # while still allowing rule updates via aws_security_group_rule.
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ingress" {
  for_each = local.ingress_rules_by_key

  type              = "ingress"
  security_group_id = aws_security_group.this.id

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = lower(each.value.protocol)
  description = try(each.value.description, null)

  cidr_blocks      = try(length(each.value.cidr_blocks), 0) > 0 ? each.value.cidr_blocks : null
  ipv6_cidr_blocks = try(length(each.value.ipv6_cidr_blocks), 0) > 0 ? each.value.ipv6_cidr_blocks : null
  prefix_list_ids  = try(length(each.value.prefix_list_ids), 0) > 0 ? each.value.prefix_list_ids : null

  source_security_group_id = try(trimspace(each.value.source_security_group_id), "") != "" ? each.value.source_security_group_id : null
}

resource "aws_security_group_rule" "egress" {
  for_each = local.egress_rules_by_key

  type              = "egress"
  security_group_id = aws_security_group.this.id

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = lower(each.value.protocol)
  description = try(each.value.description, null)

  cidr_blocks      = try(length(each.value.cidr_blocks), 0) > 0 ? each.value.cidr_blocks : null
  ipv6_cidr_blocks = try(length(each.value.ipv6_cidr_blocks), 0) > 0 ? each.value.ipv6_cidr_blocks : null
  prefix_list_ids  = try(length(each.value.prefix_list_ids), 0) > 0 ? each.value.prefix_list_ids : null
}
