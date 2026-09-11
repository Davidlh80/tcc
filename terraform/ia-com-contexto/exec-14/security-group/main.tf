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

  tags = merge(local.mandatory_tags, var.additional_tags)
}

resource "aws_security_group" "sg" {
  name                   = var.security_group_name
  description            = var.security_group_description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  dynamic "ingress" {
    for_each = var.security_group_ingress_rules
    content {
      description      = ingress.value.description
      protocol         = ingress.value.protocol
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      cidr_blocks      = coalesce(ingress.value.cidr_blocks, [])
      ipv6_cidr_blocks = coalesce(ingress.value.ipv6_cidr_blocks, [])
      security_groups  = coalesce(ingress.value.security_groups, [])
      self             = coalesce(ingress.value.self, false)
    }
  }

  dynamic "egress" {
    for_each = var.security_group_egress_rules
    content {
      description      = egress.value.description
      protocol         = egress.value.protocol
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      cidr_blocks      = coalesce(egress.value.cidr_blocks, [])
      ipv6_cidr_blocks = coalesce(egress.value.ipv6_cidr_blocks, [])
      security_groups  = coalesce(egress.value.security_groups, [])
      self             = coalesce(egress.value.self, false)
    }
  }

  tags = local.tags

  lifecycle {
    precondition {
      condition = can(regex("^${var.environment}-${var.system}-sg-[a-z0-9-]+$", var.security_group_name))
      error_message = "security_group_name must follow the pattern <environment>-<system>-sg-<purpose> and match the provided environment and system."
    }
    precondition {
      condition = alltrue([
        for r in var.security_group_ingress_rules :
        (contains(coalesce(r.cidr_blocks, []), "0.0.0.0/0") || contains(coalesce(r.ipv6_cidr_blocks, []), "::/0"))
        ? (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
        : true
      ])
      error_message = "Ingress rules cannot allow 0.0.0.0/0 or ::/0 except exactly tcp/443."
    }
    precondition {
      condition = alltrue([
        for r in var.security_group_egress_rules :
        (contains(coalesce(r.cidr_blocks, []), "0.0.0.0/0") || contains(coalesce(r.ipv6_cidr_blocks, []), "::/0"))
        ? (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
        : true
      ])
      error_message = "Egress rules cannot allow 0.0.0.0/0 or ::/0 except exactly tcp/443."
    }
    precondition {
      condition = alltrue([for r in var.security_group_ingress_rules : length(trim(r.description)) > 0])
      error_message = "All ingress rules must include a non-empty description."
    }
    precondition {
      condition = alltrue([for r in var.security_group_egress_rules : length(trim(r.description)) > 0])
      error_message = "All egress rules must include a non-empty description."
    }
  }
}
