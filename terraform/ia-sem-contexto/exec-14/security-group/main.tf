provider "aws" {
  region = var.region
}

locals {
  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )

  ingress_base_rules = {
    for idx, r in var.ingress_rules :
    idx => r
    if length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.prefix_list_ids) + (r.self ? 1 : 0) > 0
  }

  ingress_peer_rules = {
    for pr in flatten([
      for idx, r in var.ingress_rules : [
        for sg in r.peer_security_group_ids : {
          key         = "${idx}-${sg}"
          from_port   = r.from_port
          to_port     = r.to_port
          protocol    = r.protocol
          description = coalesce(r.description, "Ingress from peer SG")
          peer_sg_id  = sg
        }
      ]
    ]) : pr.key => pr
  }

  egress_base_rules = {
    for idx, r in var.egress_rules :
    idx => r
    if length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.prefix_list_ids) > 0
  }

  egress_peer_rules = {
    for pr in flatten([
      for idx, r in var.egress_rules : [
        for sg in r.peer_security_group_ids : {
          key         = "${idx}-${sg}"
          from_port   = r.from_port
          to_port     = r.to_port
          protocol    = r.protocol
          description = coalesce(r.description, "Egress to peer SG")
          peer_sg_id  = sg
        }
      ]
    ]) : pr.key => pr
  }
}

resource "aws_security_group" "this" {
  name                   = var.name
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  # Bloqueia tudo por padrão (seguro). As regras são gerenciadas via aws_security_group_rule.
  ingress = []
  egress  = []

  tags = local.tags
}

resource "aws_security_group_rule" "ingress_base" {
  for_each = local.ingress_base_rules

  type              = "ingress"
  security_group_id = aws_security_group.this.id
  description       = coalesce(each.value.description, "Ingress rule")
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port

  cidr_blocks       = each.value.cidr_blocks
  ipv6_cidr_blocks  = each.value.ipv6_cidr_blocks
  prefix_list_ids   = each.value.prefix_list_ids
  self              = try(each.value.self, false)
}

resource "aws_security_group_rule" "ingress_peers" {
  for_each = local.ingress_peer_rules

  type                     = "ingress"
  security_group_id        = aws_security_group.this.id
  description              = each.value.description
  protocol                 = each.value.protocol
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  source_security_group_id = each.value.peer_sg_id
}

resource "aws_security_group_rule" "egress_base" {
  for_each = local.egress_base_rules

  type              = "egress"
  security_group_id = aws_security_group.this.id
  description       = coalesce(each.value.description, "Egress rule")
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port

  cidr_blocks      = each.value.cidr_blocks
  ipv6_cidr_blocks = each.value.ipv6_cidr_blocks
  prefix_list_ids  = each.value.prefix_list_ids
}

resource "aws_security_group_rule" "egress_peers" {
  for_each = local.egress_peer_rules

  type                     = "egress"
  security_group_id        = aws_security_group.this.id
  description              = each.value.description
  protocol                 = each.value.protocol
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  source_security_group_id = each.value.peer_sg_id
}
