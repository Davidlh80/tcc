provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = merge(
    var.tags,
    {
      Name        = var.security_group_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )

  rules = {
    for pair in setproduct(var.allowed_ports, var.allowed_cidrs) :
    "${pair[0]}-${pair[1]}" => {
      port = pair[0]
      cidr = pair[1]
    }
  }
}

resource "aws_security_group" "this" {
  name        = var.security_group_name
  description = "Restricted TCP access for ${var.environment}."
  vpc_id      = var.vpc_id

  tags = local.common_tags
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = local.rules

  security_group_id = aws_security_group.this.id
  description       = "Allow TCP ${each.value.port} from ${each.value.cidr}."
  ip_protocol       = "tcp"
  from_port         = each.value.port
  to_port           = each.value.port
  cidr_ipv4         = each.value.cidr

  tags = local.common_tags
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = local.rules

  security_group_id = aws_security_group.this.id
  description       = "Allow TCP ${each.value.port} to ${each.value.cidr}."
  ip_protocol       = "tcp"
  from_port         = each.value.port
  to_port           = each.value.port
  cidr_ipv4         = each.value.cidr

  tags = local.common_tags
}
