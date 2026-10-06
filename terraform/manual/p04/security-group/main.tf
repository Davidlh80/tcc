locals {
  tags = merge(
    var.additional_tags,
    {
      Name        = var.security_group_name
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  )

  egress_cidrs = length(var.egress_cidrs) > 0 ? var.egress_cidrs : var.allowed_cidrs

  ingress_rules = {
    for pair in setproduct(var.allowed_ports, var.allowed_cidrs) :
    "${pair[0]}-${pair[1]}" => { port = pair[0], cidr = pair[1] }
  }

  egress_rules = {
    for pair in setproduct(var.egress_ports, local.egress_cidrs) :
    "${pair[0]}-${pair[1]}" => { port = pair[0], cidr = pair[1] }
  }
}

resource "aws_security_group" "this" {
  name        = var.security_group_name
  description = "Security Group ${var.security_group_name} do ambiente ${var.environment}"
  vpc_id      = var.vpc_id

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = local.ingress_rules

  security_group_id = aws_security_group.this.id
  description       = "Entrada TCP ${each.value.port} a partir de ${each.value.cidr}"
  ip_protocol       = "tcp"
  from_port         = each.value.port
  to_port           = each.value.port
  cidr_ipv4         = each.value.cidr

  tags = local.tags
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = local.egress_rules

  security_group_id = aws_security_group.this.id
  description       = "Saida TCP ${each.value.port} para ${each.value.cidr}"
  ip_protocol       = "tcp"
  from_port         = each.value.port
  to_port           = each.value.port
  cidr_ipv4         = each.value.cidr

  tags = local.tags
}
