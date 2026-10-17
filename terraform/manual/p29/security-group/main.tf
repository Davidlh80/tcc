resource "aws_security_group" "this" {
  name        = "${var.sg_name}-${var.environment}"
  description = "Security Group seguro gerido pela Terraform"
  vpc_id      = var.vpc_id


  egress {
    description = "Permitir todo o trafego de saida"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Permitir HTTPS de IPs especificos"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  tags = {
    Environment = var.environment
  }
}
