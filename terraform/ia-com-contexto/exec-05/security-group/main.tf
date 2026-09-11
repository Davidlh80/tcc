provider "aws" {
  region = var.region
}

locals {
  sg_full_name = format("%s-%s-sg-%s", var.environment, var.system, var.security_group_name)
}

resource "aws_security_group" "this" {
  name                   = local.sg_full_name
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
      security_groups  = try(ingress.value.security_groups, [])
      self             = try(ingress.value.self, false)
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
      security_groups  = try(egress.value.security_groups, [])
      self             = try(egress.value.self, false)
    }
  }

  tags = merge(
    var.additional_tags,
    {
      Project     = "tcc-iac-ia"
      Environment = var.environment
      ManagedBy   = "terraform"
      Owner       = "devops"
      CostCenter  = "academic-research"
    }
  )
}
