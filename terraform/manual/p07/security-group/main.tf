locals {
  tags = merge(var.additional_tags, {
    Name        = var.security_group_name
    Environment = var.environment
    ManagedBy   = "terraform"
  })
}

resource "aws_security_group" "main" {
  name        = var.security_group_name
  description = "Security Group ${var.security_group_name} - ${var.environment}"
  vpc_id      = var.vpc_id
  tags        = local.tags

  dynamic "ingress" {
    for_each = toset(var.allowed_ports)

    content {
      description = "Entrada TCP na porta ${ingress.value}"
      protocol    = "tcp"
      from_port   = ingress.value
      to_port     = ingress.value
      cidr_blocks = var.allowed_cidrs
    }
  }

  egress {
    description = "Saida TCP na porta ${var.egress_port}"
    protocol    = "tcp"
    from_port   = var.egress_port
    to_port     = var.egress_port
    cidr_blocks = var.egress_cidrs
  }
}
