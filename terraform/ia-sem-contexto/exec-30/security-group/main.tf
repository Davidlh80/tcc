provider "aws" {
  region = var.region
}

locals {
  default_tags = {
    ManagedBy  = "Terraform"
    CostCenter = "unspecified"
  }

  merged_tags = merge(local.default_tags, var.tags, { Name = var.name })

  ingress_cidr_rules = [
    for r in var.ingress_rules : r
    if length(r.cidr_blocks) > 0 || length(r.ipv6_cidr_blocks) > 0
  ]

  ingress_sg_pairs = flatten([
    for r in var.ingress_rules : [
      for sg in r.security_groups : merge(r, { source_sg = sg })
    ] if length(r.security_groups) > 0
  ])

  ingress_self_rules = [
    for r in var.ingress_rules : r
    if r.self
  ]

  egress_cidr_rules = [
    for r in var.egress_rules : r
    if length(r.cidr_blocks) > 0 || length(r.ipv6_cidr_blocks) > 0
  ]

  egress_sg_pairs = flatten([
    for r in var.egress_rules : [
      for sg in r.security_groups : merge(r, { source_sg = sg })
    ] if length(r.security_groups) > 0
  ])

  egress_self_rules = [
    for r in var.egress_rules : r
    if r.self
  ]
}

resource "aws_security_group" "this" {
  name                   = var.name
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete

  tags = local.merged_tags
}

resource "aws_security_group_rule" "ingress_cidr" {
  for_each = { for idx, r in local.ingress_cidr_rules : idx => r }

  type              = "ingress"
  security_group_id = aws_security_group.this.id
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = length(each.value.cidr_blocks) > 0 ? each.value.cidr_blocks : null
  ipv6_cidr_blocks  = length(each.value.ipv6_cidr_blocks) > 0 ? each.value.ipv6_cidr_blocks : null
}

resource "aws_security_group_rule" "ingress_sg" {
  for_each = { for idx, r in local.ingress_sg_pairs : idx => r }

  type                     = "ingress"
  security_group_id        = aws_security_group.this.id
  description              = each.value.description
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  source_security_group_id = each.value.source_sg
}

resource "aws_security_group_rule" "ingress_self" {
  for_each = { for idx, r in local.ingress_self_rules : idx => r }

  type              = "ingress"
  security_group_id = aws_security_group.this.id
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  self              = true
}

resource "aws_security_group_rule" "egress_cidr" {
  for_each = { for idx, r in local.egress_cidr_rules : idx => r }

  type              = "egress"
  security_group_id = aws_security_group.this.id
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = length(each.value.cidr_blocks) > 0 ? each.value.cidr_blocks : null
  ipv6_cidr_blocks  = length(each.value.ipv6_cidr_blocks) > 0 ? each.value.ipv6_cidr_blocks : null
}

resource "aws_security_group_rule" "egress_sg" {
  for_each = { for idx, r in local.egress_sg_pairs : idx => r }

  type                     = "egress"
  security_group_id        = aws_security_group.this.id
  description              = each.value.description
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  source_security_group_id = each.value.source_sg
}

resource "aws_security_group_rule" "egress_self" {
  for_each = { for idx, r in local.egress_self_rules : idx => r }

  type              = "egress"
  security_group_id = aws_security_group.this.id
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  self              = true
}
