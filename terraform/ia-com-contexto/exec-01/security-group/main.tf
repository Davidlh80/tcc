provider "aws" {
  region = var.region
}

locals {
  resource_name = "${var.environment}-${var.system}-sg-${var.security_group_name}"

  required_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags_merged = merge(var.additional_tags, local.required_tags)

  ingress_rules_expanded = flatten([
    for idx, r in var.ingress_rules : concat(
      [
        for cidr in r.ipv4_cidrs : {
          key                           = "ingress-ipv4-${idx}-${cidr}-${r.from_port}-${r.to_port}-${lower(r.protocol)}"
          description                   = r.description
          from_port                     = r.from_port
          to_port                       = r.to_port
          ip_protocol                   = lower(r.protocol)
          cidr_ipv4                     = cidr
          cidr_ipv6                     = null
          prefix_list_id                = null
          referenced_security_group_id  = null
        }
      ],
      [
        for cidr6 in r.ipv6_cidrs : {
          key                           = "ingress-ipv6-${idx}-${cidr6}-${r.from_port}-${r.to_port}-${lower(r.protocol)}"
          description                   = r.description
          from_port                     = r.from_port
          to_port                       = r.to_port
          ip_protocol                   = lower(r.protocol)
          cidr_ipv4                     = null
          cidr_ipv6                     = cidr6
          prefix_list_id                = null
          referenced_security_group_id  = null
        }
      ],
      [
        for pl in r.prefix_list_ids : {
          key                           = "ingress-pl-${idx}-${pl}-${r.from_port}-${r.to_port}-${lower(r.protocol)}"
          description                   = r.description
          from_port                     = r.from_port
          to_port                       = r.to_port
          ip_protocol                   = lower(r.protocol)
          cidr_ipv4                     = null
          cidr_ipv6                     = null
          prefix_list_id                = pl
          referenced_security_group_id  = null
        }
      ],
      [
        for sgid in r.referenced_security_group_ids : {
          key                           = "ingress-sgref-${idx}-${sgid}-${r.from_port}-${r.to_port}-${lower(r.protocol)}"
          description                   = r.description
          from_port                     = r.from_port
          to_port                       = r.to_port
          ip_protocol                   = lower(r.protocol)
          cidr_ipv4                     = null
          cidr_ipv6                     = null
          prefix_list_id                = null
          referenced_security_group_id  = sgid
        }
      ]
    )
  ])

  egress_rules_expanded = flatten([
    for idx, r in var.egress_rules : concat(
      [
        for cidr in r.ipv4_cidrs : {
          key                           = "egress-ipv4-${idx}-${cidr}-${r.from_port}-${r.to_port}-${lower(r.protocol)}"
          description                   = r.description
          from_port                     = r.from_port
          to_port                       = r.to_port
          ip_protocol                   = lower(r.protocol)
          cidr_ipv4                     = cidr
          cidr_ipv6                     = null
          prefix_list_id                = null
          referenced_security_group_id  = null
        }
      ],
      [
        for cidr6 in r.ipv6_cidrs : {
          key                           = "egress-ipv6-${idx}-${cidr6}-${r.from_port}-${r.to_port}-${lower(r.protocol)}"
          description                   = r.description
          from_port                     = r.from_port
          to_port                       = r.to_port
          ip_protocol                   = lower(r.protocol)
          cidr_ipv4                     = null
          cidr_ipv6                     = cidr6
          prefix_list_id                = null
          referenced_security_group_id  = null
        }
      ],
      [
        for pl in r.prefix_list_ids : {
          key                           = "egress-pl-${idx}-${pl}-${r.from_port}-${r.to_port}-${lower(r.protocol)}"
          description                   = r.description
          from_port                     = r.from_port
          to_port                       = r.to_port
          ip_protocol                   = lower(r.protocol)
          cidr_ipv4                     = null
          cidr_ipv6                     = null
          prefix_list_id                = pl
          referenced_security_group_id  = null
        }
      ],
      [
        for sgid in r.referenced_security_group_ids : {
          key                           = "egress-sgref-${idx}-${sgid}-${r.from_port}-${r.to_port}-${lower(r.protocol)}"
          description                   = r.description
          from_port                     = r.from_port
          to_port                       = r.to_port
          ip_protocol                   = lower(r.protocol)
          cidr_ipv4                     = null
          cidr_ipv6                     = null
          prefix_list_id                = null
          referenced_security_group_id  = sgid
        }
      ]
    )
  ])
}

resource "aws_security_group" "this" {
  name                   = local.resource_name
  description            = var.security_group_description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  # Segurança: egress explícito e sem liberação irrestrita por padrão
  egress = []

  tags = local.tags_merged
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = { for r in local.ingress_rules_expanded : r.key => r }

  security_group_id              = aws_security_group.this.id
  cidr_ipv4                      = each.value.cidr_ipv4
  cidr_ipv6                      = each.value.cidr_ipv6
  prefix_list_id                 = each.value.prefix_list_id
  referenced_security_group_id   = each.value.referenced_security_group_id
  from_port                      = each.value.from_port
  to_port                        = each.value.to_port
  ip_protocol                    = each.value.ip_protocol
  description                    = each.value.description
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = { for r in local.egress_rules_expanded : r.key => r }

  security_group_id              = aws_security_group.this.id
  cidr_ipv4                      = each.value.cidr_ipv4
  cidr_ipv6                      = each.value.cidr_ipv6
  prefix_list_id                 = each.value.prefix_list_id
  referenced_security_group_id   = each.value.referenced_security_group_id
  from_port                      = each.value.from_port
  to_port                        = each.value.to_port
  ip_protocol                    = each.value.ip_protocol
  description                    = each.value.description
}
