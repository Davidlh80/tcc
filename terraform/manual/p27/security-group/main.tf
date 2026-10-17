locals {
  common_tags = merge(var.additional_tags, {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Component   = "SecurityGroup"
  })

  ingress_rules = {
    for rule in var.ingress_rules : rule.name => rule
  }

  egress_rules = {
    for rule in var.egress_rules : rule.name => rule
  }
}

resource "aws_security_group" "this" {
  name        = "${var.environment}-${var.security_group_name}"
  description = var.description
  vpc_id      = var.vpc_id

  tags = local.common_tags

  lifecycle {
    precondition {
      condition = (
        length("${var.environment}-${var.security_group_name}") <= 255
      )
      error_message = "O nome final do Security Group excede 255 caracteres."
    }
  }
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = local.ingress_rules

  security_group_id = aws_security_group.this.id
  description       = each.value.description
  ip_protocol       = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  cidr_ipv4         = each.value.cidr_ipv4
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = local.egress_rules

  security_group_id = aws_security_group.this.id
  description       = each.value.description
  ip_protocol       = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  cidr_ipv4         = each.value.cidr_ipv4
}
