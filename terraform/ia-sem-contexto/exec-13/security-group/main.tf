provider "aws" {
  region = var.aws_region
}

locals {
  default_tags = {
    ManagedBy   = "Terraform"
    Environment = var.environment
  }

  merged_tags = merge(local.default_tags, var.tags)
}

resource "aws_security_group" "this" {
  name                   = var.name
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description      = coalesce(ingress.value.description, "")
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = lower(ingress.value.protocol)
      cidr_blocks      = length(ingress.value.cidr_blocks) > 0 ? ingress.value.cidr_blocks : null
      ipv6_cidr_blocks = length(ingress.value.ipv6_cidr_blocks) > 0 ? ingress.value.ipv6_cidr_blocks : null
      prefix_list_ids  = length(ingress.value.prefix_list_ids) > 0 ? ingress.value.prefix_list_ids : null
      security_groups  = length(ingress.value.security_groups) > 0 ? ingress.value.security_groups : null
      self             = ingress.value.self
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description      = coalesce(egress.value.description, "")
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = lower(egress.value.protocol)
      cidr_blocks      = length(egress.value.cidr_blocks) > 0 ? egress.value.cidr_blocks : null
      ipv6_cidr_blocks = length(egress.value.ipv6_cidr_blocks) > 0 ? egress.value.ipv6_cidr_blocks : null
      prefix_list_ids  = length(egress.value.prefix_list_ids) > 0 ? egress.value.prefix_list_ids : null
      security_groups  = length(egress.value.security_groups) > 0 ? egress.value.security_groups : null
      self             = egress.value.self
    }
  }

  tags = local.merged_tags

  lifecycle {
    create_before_destroy = true
  }
}
