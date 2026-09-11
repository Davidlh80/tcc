provider "aws" {
  region = var.region
}

locals {
  resource_name = "${var.environment}-${var.system}-sg-${var.security_group_name}"

  sg_description = coalesce(var.security_group_description, "Managed by Terraform")

  mandatory_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  all_tags = merge(local.mandatory_tags, var.additional_tags)
}

resource "aws_security_group" "this" {
  name                   = local.resource_name
  description            = local.sg_description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  # Remove default allow-all egress when no custom egress rules are provided
  egress = length(var.egress_rules) == 0 ? [] : null

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description      = ingress.value.description
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = try(ingress.value.cidr_blocks, [])
      ipv6_cidr_blocks = try(ingress.value.ipv6_cidr_blocks, [])
      prefix_list_ids  = try(ingress.value.prefix_list_ids, [])
      security_groups  = try(ingress.value.security_groups, [])
      self             = try(ingress.value.self, false)
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description      = egress.value.description
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      cidr_blocks      = try(egress.value.cidr_blocks, [])
      ipv6_cidr_blocks = try(egress.value.ipv6_cidr_blocks, [])
      prefix_list_ids  = try(egress.value.prefix_list_ids, [])
      security_groups  = try(egress.value.security_groups, [])
      self             = try(egress.value.self, false)
    }
  }

  tags = local.all_tags

  lifecycle {
    create_before_destroy = true
  }
}
