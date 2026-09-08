provider "aws" {
  region = var.aws_region
}

locals {
  // Construct a sensible default Name tag when name is not provided
  default_name_tag = coalesce(var.name, "${var.name_prefix}default")

  // Ingress rules expanded to single-destination items
  ingress_items_ipv4 = flatten([
    for rule in var.ingress_rules : [
      for cidr in coalesce(rule.cidr_blocks, []) : {
        description = try(rule.description, null)
        from_port   = rule.from_port
        to_port     = rule.to_port
        protocol    = rule.protocol
        cidr_ipv4   = cidr
      }
    ]
  ])

  ingress_items_ipv6 = flatten([
    for rule in var.ingress_rules : [
      for cidr in coalesce(rule.ipv6_cidr_blocks, []) : {
        description = try(rule.description, null)
        from_port   = rule.from_port
        to_port     = rule.to_port
        protocol    = rule.protocol
        cidr_ipv6   = cidr
      }
    ]
  ])

  ingress_items_sg = flatten([
    for rule in var.ingress_rules : [
      for sg in coalesce(rule.security_groups, []) : {
        description                   = try(rule.description, null)
        from_port                     = rule.from_port
        to_port                       = rule.to_port
        protocol                      = rule.protocol
        referenced_security_group_id  = sg
      }
    ]
  ])

  ingress_rules_map = {
    for r in concat(local.ingress_items_ipv4, local.ingress_items_ipv6, local.ingress_items_sg) :
    format(
      "ingress|%s|%s|%s|%s|%s",
      r.protocol,
      tostring(try(r.from_port, -1)),
      tostring(try(r.to_port, -1)),
      try(replace(r.cidr_ipv4, "/", "_"), try(replace(r.cidr_ipv6, "/", "_"), try(r.referenced_security_group_id, "none"))),
      try(replace(r.description, "|", "_"), "no-desc")
    ) => r
  }

  // Egress rules expanded to single-destination items
  egress_items_ipv4 = flatten([
    for rule in var.egress_rules : [
      for cidr in coalesce(rule.cidr_blocks, []) : {
        description = try(rule.description, null)
        from_port   = rule.from_port
        to_port     = rule.to_port
        protocol    = rule.protocol
        cidr_ipv4   = cidr
      }
    ]
  ])

  egress_items_ipv6 = flatten([
    for rule in var.egress_rules : [
      for cidr in coalesce(rule.ipv6_cidr_blocks, []) : {
        description = try(rule.description, null)
        from_port   = rule.from_port
        to_port     = rule.to_port
        protocol    = rule.protocol
        cidr_ipv6   = cidr
      }
    ]
  ])

  egress_items_sg = flatten([
    for rule in var.egress_rules : [
      for sg in coalesce(rule.security_groups, []) : {
        description                   = try(rule.description, null)
        from_port                     = rule.from_port
        to_port                       = rule.to_port
        protocol                      = rule.protocol
        referenced_security_group_id  = sg
      }
    ]
  ])

  egress_rules_map = {
    for r in concat(local.egress_items_ipv4, local.egress_items_ipv6, local.egress_items_sg) :
    format(
      "egress|%s|%s|%s|%s|%s",
      r.protocol,
      tostring(try(r.from_port, -1)),
      tostring(try(r.to_port, -1)),
      try(replace(r.cidr_ipv4, "/", "_"), try(replace(r.cidr_ipv6, "/", "_"), try(r.referenced_security_group_id, "none"))),
      try(replace(r.description, "|", "_"), "no-desc")
    ) => r
  }
}

resource "aws_security_group" "this" {
  name        = var.name
  name_prefix = var.name == null ? var.name_prefix : null
  description = var.description
  vpc_id      = var.vpc_id

  // Security-first: block all egress by default. Specific egress is managed below by dedicated resources.
  egress = []

  revoke_rules_on_delete = true

  tags = merge(
    {
      Name = local.default_name_tag
    },
    var.tags
  )
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = local.ingress_rules_map

  security_group_id = aws_security_group.this.id
  description       = try(each.value.description, null)

  ip_protocol = each.value.protocol
  from_port   = each.value.protocol == "-1" ? null : try(each.value.from_port, null)
  to_port     = each.value.protocol == "-1" ? null : try(each.value.to_port, null)

  cidr_ipv4                    = try(each.value.cidr_ipv4, null)
  cidr_ipv6                    = try(each.value.cidr_ipv6, null)
  referenced_security_group_id = try(each.value.referenced_security_group_id, null)
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = local.egress_rules_map

  security_group_id = aws_security_group.this.id
  description       = try(each.value.description, null)

  ip_protocol = each.value.protocol
  from_port   = each.value.protocol == "-1" ? null : try(each.value.from_port, null)
  to_port     = each.value.protocol == "-1" ? null : try(each.value.to_port, null)

  cidr_ipv4                    = try(each.value.cidr_ipv4, null)
  cidr_ipv6                    = try(each.value.cidr_ipv6, null)
  referenced_security_group_id = try(each.value.referenced_security_group_id, null)
}
