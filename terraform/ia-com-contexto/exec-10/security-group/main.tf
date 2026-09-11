provider "aws" {
  region = var.region
}

locals {
  resource = "sg"

  name = "${var.environment}-${var.system}-${local.resource}-${var.security_group_name}"

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
  name                   = local.name
  description            = var.security_group_description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description      = ingress.value.description
      protocol         = ingress.value.protocol
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      cidr_blocks      = try(ingress.value.cidr_blocks, [])
      ipv6_cidr_blocks = try(ingress.value.ipv6_cidr_blocks, [])
      security_groups  = try(ingress.value.source_security_group_ids, [])
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description      = egress.value.description
      protocol         = egress.value.protocol
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      cidr_blocks      = try(egress.value.cidr_blocks, [])
      ipv6_cidr_blocks = try(egress.value.ipv6_cidr_blocks, [])
      security_groups  = try(egress.value.source_security_group_ids, [])
    }
  }

  tags = local.tags
}
