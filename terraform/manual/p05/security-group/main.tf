locals {
  tags = merge(var.additional_tags, {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  })
}

resource "aws_security_group" "this" {
  name        = var.security_group_name
  description = "Security Group ${var.security_group_name} (${var.environment})"
  vpc_id      = var.vpc_id
  tags        = merge(local.tags, { Name = var.security_group_name })
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = {
    for pair in setproduct(var.allowed_ports, var.allowed_cidrs) :
    "${pair[0]}-${pair[1]}" => { port = pair[0], cidr = pair[1] }
  }

  security_group_id = aws_security_group.this.id
  description       = "Entrada TCP ${each.value.port} de ${each.value.cidr}"
  ip_protocol       = "tcp"
  from_port         = each.value.port
  to_port           = each.value.port
  cidr_ipv4         = each.value.cidr
  tags              = local.tags
}

resource "aws_vpc_security_group_egress_rule" "https" {
  for_each = toset(var.egress_cidrs)

  security_group_id = aws_security_group.this.id
  description       = "Saida HTTPS para ${each.value}"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = each.value
  tags              = local.tags
}
