provider "aws" {
  region = var.region
}

locals {
  sg_name = "${var.environment}-${var.system}-sg-${var.security_group_name}"

  required_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  ingress_rules_by_index = {
    for idx, r in var.ingress_rules :
    format("%03d", idx) => r
  }

  egress_rules_by_index = {
    for idx, r in var.egress_rules :
    format("%03d", idx) => r
  }
}

resource "aws_security_group" "this" {
  name        = local.sg_name
  description = var.security_group_description
  vpc_id      = var.vpc_id

  # Enforce explicit egress rules (no implicit allow-all)
  egress = []

  revoke_rules_on_delete = true

  tags = merge(local.required_tags, var.additional_tags)
}

resource "aws_security_group_rule" "ingress" {
  for_each = local.ingress_rules_by_index

  type              = "ingress"
  description       = each.value.description
  security_group_id = aws_security_group.this.id

  protocol  = each.value.protocol
  from_port = each.value.from_port
  to_port   = each.value.to_port

  cidr_blocks      = lookup(each.value, "cidr_blocks", [])
  ipv6_cidr_blocks = lookup(each.value, "ipv6_cidr_blocks", [])
}

resource "aws_security_group_rule" "egress" {
  for_each = local.egress_rules_by_index

  type              = "egress"
  description       = each.value.description
  security_group_id = aws_security_group.this.id

  protocol  = each.value.protocol
  from_port = each.value.from_port
  to_port   = each.value.to_port

  cidr_blocks      = lookup(each.value, "cidr_blocks", [])
  ipv6_cidr_blocks = lookup(each.value, "ipv6_cidr_blocks", [])
}
