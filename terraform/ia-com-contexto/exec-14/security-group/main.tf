locals {
  security_group_name = "${var.environment}-${var.system}-sg-${var.security_group_name}"

  tags = merge(
    {
      Project     = "tcc-iac-ia"
      Environment = var.environment
      ManagedBy   = "terraform"
      Owner       = "devops"
      CostCenter  = "academic-research"
      Name        = local.security_group_name
    },
    var.additional_tags
  )
}

provider "aws" {
  region = var.region
}

resource "aws_security_group" "this" {
  name        = local.security_group_name
  description = var.description
  vpc_id      = var.vpc_id

  tags = local.tags
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = { for idx, rule in var.ingress_rules : tostring(idx) => rule }

  security_group_id = aws_security_group.this.id
  description       = each.value.description
  ip_protocol        = each.value.protocol
  from_port          = each.value.from_port
  to_port            = each.value.to_port
  cidr_ipv4          = each.value.cidr_ipv4

  tags = local.tags
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = { for idx, rule in var.egress_rules : tostring(idx) => rule }

  security_group_id = aws_security_group.this.id
  description       = each.value.description
  ip_protocol        = each.value.protocol
  from_port          = each.value.from_port
  to_port            = each.value.to_port
  cidr_ipv4          = each.value.cidr_ipv4

  tags = local.tags
}
