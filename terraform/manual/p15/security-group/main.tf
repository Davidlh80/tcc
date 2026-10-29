locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# VPC default da conta
data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "app" {
  name        = "${local.name_prefix}-app-sg"
  description = "SG da aplicacao: HTTPS publico e SSH restrito"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "${local.name_prefix}-app-sg"
  }
}

# INGRESS: HTTPS
resource "aws_vpc_security_group_ingress_rule" "https" {
  for_each = toset(var.allowed_https_cidrs)

  security_group_id = aws_security_group.app.id
  description       = "HTTPS"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = each.value
}

# INGRESS: SSH só do seu IP
resource "aws_vpc_security_group_ingress_rule" "ssh_admin" {
  security_group_id = aws_security_group.app.id
  description       = "SSH somente do administrador"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = var.admin_ssh_cidr
}

# EGRESS: HTTPS de saída
resource "aws_vpc_security_group_egress_rule" "https_out" {
  security_group_id = aws_security_group.app.id
  description       = "Saida HTTPS"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}

# EGRESS: HTTP de saída
resource "aws_vpc_security_group_egress_rule" "http_out" {
  security_group_id = aws_security_group.app.id
  description       = "Saida HTTP"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}
