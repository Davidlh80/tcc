locals {
  tags = merge(
    {
      Project     = "tcc"
      Environment = var.environment
      ManagedBy   = "terraform"
    },
    var.additional_tags
  )
}

resource "aws_security_group" "this" {
  name        = var.security_group_name
  description = "Security Group do template TCC"
  vpc_id      = var.vpc_id
  tags        = local.tags

  dynamic "ingress" {
    for_each = var.allowed_ports

    content {
      description = "Entrada TCP liberada"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.allowed_cidrs
    }
  }

  egress {
    description = "Saída HTTPS para a rede interna"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.egress_cidrs
  }

}

