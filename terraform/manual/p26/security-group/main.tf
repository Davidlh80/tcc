locals {
  tags = merge(
    var.tags,
    {
      Name        = var.security_group_name
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  )

  ingress_rules = {
    for pair in setproduct(var.allowed_ports, var.allowed_cidrs) :
    "${pair[0]}-${pair[1]}" => { port = pair[0], cidr = pair[1] }
  }

  egress_cidrs = coalesce(var.egress_cidrs, var.allowed_cidrs)
}

resource "aws_security_group" "this" {
  name        = var.security_group_name
  description = "Security Group ${var.security_group_name} (${var.environment})"
  vpc_id      = var.vpc_id
  tags        = local.tags
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = local.ingress_rules

  security_group_id = aws_security_group.this.id
  description       = "TCP ${each.value.port} a partir de ${each.value.cidr}"
  ip_protocol       = "tcp"
  from_port         = each.value.port
  to_port           = each.value.port
  cidr_ipv4         = each.value.cidr
  tags              = local.tags
}

resource "aws_vpc_security_group_egress_rule" "https" {
  for_each = toset(local.egress_cidrs)

  security_group_id = aws_security_group.this.id
  description       = "HTTPS de saída para ${each.value}"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = each.value
  tags              = local.tags
}
