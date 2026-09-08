provider "aws" {
  region = var.region
}

locals {
  ingress_rules_count = length(var.ingress_cidr_rules) + length(var.ingress_sg_rules)
  egress_rules_count  = length(var.egress_cidr_rules) + length(var.egress_sg_rules)

  tags = merge(
    {
      Name      = var.name
      ManagedBy = "Terraform"
    },
    var.tags
  )
}

resource "aws_security_group" "this" {
  name                   = var.name
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  dynamic "ingress" {
    for_each = var.ingress_cidr_rules
    content {
      description      = ingress.value.description
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = length(ingress.value.cidr_blocks) > 0 ? ingress.value.cidr_blocks : null
      ipv6_cidr_blocks = length(ingress.value.ipv6_cidr_blocks) > 0 ? ingress.value.ipv6_cidr_blocks : null
    }
  }

  dynamic "ingress" {
    for_each = var.ingress_sg_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      self        = ingress.value.self
      security_groups = ingress.value.self
        ? null
        : (length(ingress.value.source_security_group_id) > 0 ? [ingress.value.source_security_group_id] : null)
    }
  }

  dynamic "egress" {
    for_each = var.egress_cidr_rules
    content {
      description      = egress.value.description
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      cidr_blocks      = length(egress.value.cidr_blocks) > 0 ? egress.value.cidr_blocks : null
      ipv6_cidr_blocks = length(egress.value.ipv6_cidr_blocks) > 0 ? egress.value.ipv6_cidr_blocks : null
    }
  }

  dynamic "egress" {
    for_each = var.egress_sg_rules
    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      self        = egress.value.self
      security_groups = egress.value.self
        ? null
        : (length(egress.value.destination_security_group_id) > 0 ? [egress.value.destination_security_group_id] : null)
    }
  }

  tags = local.tags
}
