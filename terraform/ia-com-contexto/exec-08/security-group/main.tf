provider "aws" {
  region = var.region
}

locals {
  sg_name = "${var.environment}-${var.system}-sg-${var.security_group_name}"

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
  name        = local.sg_name
  description = coalesce(var.security_group_description, "Security group for ${local.sg_name}")
  vpc_id      = var.vpc_id

  # Política: Egress explícito e não irrestrito por padrão
  # Definir explícito vazio remove a regra padrão de saída "allow all"
  egress = []

  revoke_rules_on_delete = true

  tags = local.all_tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ingress" {
  for_each = {
    for idx, rule in var.ingress_rules : idx => rule
  }

  type              = "ingress"
  security_group_id = aws_security_group.this.id

  description       = each.value.description
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  cidr_blocks       = try(each.value.cidr_blocks, [])
  ipv6_cidr_blocks  = try(each.value.ipv6_cidr_blocks, [])
}

resource "aws_security_group_rule" "egress" {
  for_each = {
    for idx, rule in var.egress_rules : idx => rule
  }

  type              = "egress"
  security_group_id = aws_security_group.this.id

  description       = each.value.description
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  cidr_blocks       = try(each.value.cidr_blocks, [])
  ipv6_cidr_blocks  = try(each.value.ipv6_cidr_blocks, [])
}
