locals {
  resource_name = "${var.environment}-${var.system}-sg-${var.security_group_name}"

  required_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags = merge(var.additional_tags, local.required_tags)
}

resource "aws_security_group" "this" {
  name        = local.resource_name
  description = var.security_group_description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description      = ingress.value.description
      protocol         = ingress.value.protocol
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      cidr_blocks      = try(ingress.value.cidr_blocks, null)
      ipv6_cidr_blocks = try(ingress.value.ipv6_cidr_blocks, null)
      security_groups  = try(ingress.value.security_groups, null)
      self             = try(ingress.value.self, null)
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description      = egress.value.description
      protocol         = egress.value.protocol
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      cidr_blocks      = try(egress.value.cidr_blocks, null)
      ipv6_cidr_blocks = try(egress.value.ipv6_cidr_blocks, null)
      security_groups  = try(egress.value.security_groups, null)
      self             = try(egress.value.self, null)
    }
  }

  revoke_rules_on_delete = true

  tags = local.tags
}
