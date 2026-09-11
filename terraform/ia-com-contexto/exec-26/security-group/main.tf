locals {
  resource_name = "${var.environment}-${var.system}-sg-${var.security_group_name}"

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

provider "aws" {
  region = var.region
}

resource "aws_security_group" "this" {
  name        = local.resource_name
  description = var.security_group_description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol

      cidr_blocks       = length(ingress.value.cidr_blocks) > 0 ? ingress.value.cidr_blocks : null
      ipv6_cidr_blocks  = length(ingress.value.ipv6_cidr_blocks) > 0 ? ingress.value.ipv6_cidr_blocks : null
      security_groups   = length(ingress.value.source_security_group_ids) > 0 ? ingress.value.source_security_group_ids : null
      self              = contains(ingress.value.source_security_group_ids, "self")
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol

      cidr_blocks     = length(egress.value.cidr_blocks) > 0 ? egress.value.cidr_blocks : null
      ipv6_cidr_blocks = length(egress.value.ipv6_cidr_blocks) > 0 ? egress.value.ipv6_cidr_blocks : null
      security_groups = length(egress.value.destination_security_group_ids) > 0 ? egress.value.destination_security_group_ids : null
      self            = contains(egress.value.destination_security_group_ids, "self")
    }
  }

  tags = local.tags
}
