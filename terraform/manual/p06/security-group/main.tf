resource "aws_security_group" "app" {
  name        = var.name
  description = "Acesso controlado a aplicacao"
  vpc_id      = var.vpc_id
  tags        = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "app" {
  for_each = toset(var.allowed_cidr_blocks)

  security_group_id = aws_security_group.app.id
  description       = "Trafego de aplicacao a partir das redes autorizadas"
  ip_protocol       = "tcp"
  from_port         = var.app_port
  to_port           = var.app_port
  cidr_ipv4         = each.value
}

resource "aws_vpc_security_group_egress_rule" "https" {
  security_group_id = aws_security_group.app.id
  description       = "Saida HTTPS para atualizacoes e APIs"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}
