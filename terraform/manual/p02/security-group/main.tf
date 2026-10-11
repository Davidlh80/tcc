resource "aws_security_group" "this" {
  name        = var.security_group_name
  description = "Security Group gerenciado pelo Terraform"
  vpc_id      = var.vpc_id

  tags = {
    Name      = var.security_group_name
    ManagedBy = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.this.id

  description = "SSH de IP autorizado"
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_ipv4   = var.allowed_ssh_cidr
}

resource "aws_vpc_security_group_egress_rule" "all_ipv4" {
  security_group_id = aws_security_group.this.id

  description = "Trafego de saida IPv4"
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}
