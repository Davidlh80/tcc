provider "aws" {
  region = var.region
}

locals {
  standard_tags = merge({
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }, var.additional_tags)

  sg_name = "${var.environment}-${var.system}-sg-${var.security_group_name}"
}

resource "aws_security_group" "this" {
  name        = local.sg_name
  description = var.security_group_description
  vpc_id      = var.vpc_id

  revoke_rules_on_delete                   = true
  replace_security_group_rules_during_update = true

  tags = local.standard_tags

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description      = ingress.value.description
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = ingress.value.cidr_blocks
      ipv6_cidr_blocks = ingress.value.ipv6_cidr_blocks
      security_groups  = ingress.value.security_groups
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description      = egress.value.description
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      cidr_blocks      = egress.value.cidr_blocks
      ipv6_cidr_blocks = egress.value.ipv6_cidr_blocks
      security_groups  = egress.value.security_groups
    }
  }
}
