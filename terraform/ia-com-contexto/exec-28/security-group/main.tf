provider "aws" {
  region = var.region
}

locals {
  mandatory_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags = merge(var.additional_tags, local.mandatory_tags)

  security_group_full_name = "${var.environment}-${var.system}-sg-${var.security_group_name}"
}

resource "aws_security_group" "this" {
  name                   = local.security_group_full_name
  description            = var.security_group_description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description      = ingress.value.description
      protocol         = lower(ingress.value.protocol)
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      cidr_blocks      = ingress.value.cidr_blocks
      ipv6_cidr_blocks = ingress.value.ipv6_cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description      = egress.value.description
      protocol         = lower(egress.value.protocol)
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      cidr_blocks      = egress.value.cidr_blocks
      ipv6_cidr_blocks = egress.value.ipv6_cidr_blocks
    }
  }

  tags = local.tags
}
