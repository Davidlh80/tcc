provider "aws" {
  region = var.region
}

locals {
  resource_name = "${var.environment}-${var.system}-sg-${var.security_group_name}"

  mandatory_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags = merge(
    var.additional_tags,
    local.mandatory_tags
  )

  ingress_cidr4_rules = flatten([
    for r in var.ingress_rules : [
      for cidr in r.cidr_blocks : {
        description = r.description
        from_port   = r.from_port
        to_port     = r.to_port
        protocol    = r.protocol
        cidr_block  = cidr
      }
    ]
  ])

  ingress_cidr6_rules = flatten([
    for r in var.ingress_rules : [
      for cidr in r.ipv6_cidr_blocks : {
        description = r.description
        from_port   = r.from_port
        to_port     = r.to_port
        protocol    = r.protocol
        cidr_block  = cidr
      }
    ]
  ])

  egress_cidr4_rules = flatten([
    for r in var.egress_rules : [
      for cidr in r.cidr_blocks : {
        description = r.description
        from_port   = r.from_port
        to_port     = r.to_port
        protocol    = r.protocol
        cidr_block  = cidr
      }
    ]
  ])

  egress_cidr6_rules = flatten([
    for r in var.egress_rules : [
      for cidr in r.ipv6_cidr_blocks : {
        description = r.description
        from_port   = r.from_port
        to_port     = r.to_port
        protocol    = r.protocol
        cidr_block  = cidr
      }
    ]
  ])
}

resource "aws_security_group" "this" {
  name                   = local.resource_name
  description            = var.security_group_description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  tags = local.tags
}

resource "aws_vpc_security_group_ingress_rule" "ipv4" {
  for_each = {
    for idx, r in local.ingress_cidr4_rules :
    "ing4-${idx}-${r.cidr_block}-${r.from_port}-${r.to_port}-${lower(r.protocol)}" => r
  }

  security_group_id = aws_security_group.this.id
  cidr_ipv4         = each.value.cidr_block
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = lower(each.value.protocol)
  description       = each.value.description
}

resource "aws_vpc_security_group_ingress_rule" "ipv6" {
  for_each = {
    for idx, r in local.ingress_cidr6_rules :
    "ing6-${idx}-${r.cidr_block}-${r.from_port}-${r.to_port}-${lower(r.protocol)}" => r
  }

  security_group_id = aws_security_group.this.id
  cidr_ipv6         = each.value.cidr_block
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = lower(each.value.protocol)
  description       = each.value.description
}

resource "aws_vpc_security_group_egress_rule" "ipv4" {
  for_each = {
    for idx, r in local.egress_cidr4_rules :
    "eg4-${idx}-${r.cidr_block}-${r.from_port}-${r.to_port}-${lower(r.protocol)}" => r
  }

  security_group_id = aws_security_group.this.id
  cidr_ipv4         = each.value.cidr_block
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = lower(each.value.protocol)
  description       = each.value.description
}

resource "aws_vpc_security_group_egress_rule" "ipv6" {
  for_each = {
    for idx, r in local.egress_cidr6_rules :
    "eg6-${idx}-${r.cidr_block}-${r.from_port}-${r.to_port}-${lower(r.protocol)}" => r
  }

  security_group_id = aws_security_group.this.id
  cidr_ipv6         = each.value.cidr_block
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = lower(each.value.protocol)
  description       = each.value.description
}
