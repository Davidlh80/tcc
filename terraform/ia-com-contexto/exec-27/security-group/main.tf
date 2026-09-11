provider "aws" {
  region = var.region
}

locals {
  security_group_final_name = "${var.environment}-${var.system}-sg-${var.security_group_name}"

  required_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags = merge(local.required_tags, var.additional_tags)
}

resource "aws_security_group" "this" {
  name        = local.security_group_final_name
  description = var.security_group_description
  vpc_id      = var.vpc_id

  revoke_rules_on_delete = true

  # Gestão explícita de regras via aws_security_group_rule
  # Garante que não exista egress irrestrito por padrão
  ingress = []
  egress  = []

  tags = local.tags
}

resource "aws_security_group_rule" "ingress" {
  for_each = { for idx, rule in var.ingress_rules : tostring(idx) => rule }

  type              = "ingress"
  security_group_id = aws_security_group.this.id

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
  description = each.value.description

  cidr_blocks      = length(each.value.cidr_blocks) > 0 ? each.value.cidr_blocks : null
  ipv6_cidr_blocks = length(each.value.ipv6_cidr_blocks) > 0 ? each.value.ipv6_cidr_blocks : null
}

resource "aws_security_group_rule" "egress" {
  for_each = { for idx, rule in var.egress_rules : tostring(idx) => rule }

  type              = "egress"
  security_group_id = aws_security_group.this.id

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
  description = each.value.description

  cidr_blocks      = length(each.value.cidr_blocks) > 0 ? each.value.cidr_blocks : null
  ipv6_cidr_blocks = length(each.value.ipv6_cidr_blocks) > 0 ? each.value.ipv6_cidr_blocks : null
}
