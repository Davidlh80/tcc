terraform {
  required_version = ">= 1.5.0"
}

locals {
  name = var.name != "" ? var.name : "sg-${var.environment}"

  common_tags = merge(
    {
      Name        = local.name
      Environment = var.environment
      ManagedBy   = "terraform"
    },
    var.tags
  )
}

resource "aws_security_group" "this" {
  name        = local.name
  description = var.description
  vpc_id      = var.vpc_id

  tags = local.common_tags
}

resource "aws_security_group_rule" "ingress" {
  for_each = { for idx, rule in var.ingress_rules : idx => rule }

  type              = "ingress"
  security_group_id = aws_security_group.this.id
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
}

resource "aws_security_group_rule" "egress" {
  for_each = { for idx, rule in var.egress_rules : idx => rule }

  type              = "egress"
  security_group_id = aws_security_group.this.id
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
}
