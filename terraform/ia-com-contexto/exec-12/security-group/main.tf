locals {
  name = "${var.environment}-${var.system}-sg-${var.security_group_name}"

  tags = merge(
    {
      Project     = "tcc-iac-ia"
      Environment = var.environment
      ManagedBy   = "terraform"
      Owner       = "devops"
      CostCenter  = "academic-research"
    },
    var.additional_tags
  )
}

resource "aws_security_group" "this" {
  name        = local.name
  description = var.description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = merge(
    local.tags,
    {
      Name = local.name
    }
  )
}
