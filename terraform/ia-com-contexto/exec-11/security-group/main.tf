provider "aws" {
  region = var.region
}

locals {
  sg_name = "${var.environment}-${var.system}-sg-${var.security_group_name}"

  base_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags = merge(var.additional_tags, local.base_tags)
}

resource "aws_security_group" "this" {
  name                   = local.sg_name
  description            = var.security_group_description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  # Regras explícitas são gerenciadas via recursos dedicados abaixo.
  # Mantemos inline vazias para evitar liberação irrestrita por padrão.
  ingress = []
  egress  = []

  tags = local.tags
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = { for idx, r in var.ingress_rules : tostring(idx) => r }

  security_group_id = aws_security_group.this.id
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = lower(each.value.protocol)

  cidr_ipv4                    = try(each.value.cidr_ipv4, null)
  cidr_ipv6                    = try(each.value.cidr_ipv6, null)
  prefix_list_id               = try(each.value.prefix_list_id, null)
  referenced_security_group_id = each.value.self ? aws_security_group.this.id : try(each.value.referenced_security_group_id, null)
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = { for idx, r in var.egress_rules : tostring(idx) => r }

  security_group_id = aws_security_group.this.id
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = lower(each.value.protocol)

  cidr_ipv4                    = try(each.value.cidr_ipv4, null)
  cidr_ipv6                    = try(each.value.cidr_ipv6, null)
  prefix_list_id               = try(each.value.prefix_list_id, null)
  referenced_security_group_id = each.value.self ? aws_security_group.this.id : try(each.value.referenced_security_group_id, null)
}
