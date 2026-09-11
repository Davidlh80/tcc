provider "aws" {
  region = var.region
}

locals {
  # Nome padronizado: <environment>-<system>-sg-<security_group_name>
  security_group_full_name = "${var.environment}-${var.system}-sg-${var.security_group_name}"

  mandatory_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  common_tags = merge(local.mandatory_tags, var.additional_tags)

  # Mapas para for_each com chaves estáveis
  ingress_rules_map = {
    for idx, r in var.ingress_rules :
    format("%03d-%s-%s-%d-%d", idx, r.protocol, replace(lower(trim(r.description)), " ", "-"), r.from_port, r.to_port) => r
  }

  egress_rules_map = {
    for idx, r in var.egress_rules :
    format("%03d-%s-%s-%d-%d", idx, r.protocol, replace(lower(trim(r.description)), " ", "-"), r.from_port, r.to_port) => r
  }
}

resource "aws_security_group" "this" {
  name        = local.security_group_full_name
  description = var.security_group_description
  vpc_id      = var.vpc_id

  # Egress explícito e restritivo por padrão (sem liberação irrestrita)
  # Mantido vazio; regras de saída são gerenciadas via aws_security_group_rule.egress
  egress = []

  revoke_rules_on_delete = true

  tags = local.common_tags
}

resource "aws_security_group_rule" "ingress" {
  for_each = local.ingress_rules_map

  type              = "ingress"
  security_group_id = aws_security_group.this.id

  description = each.value.description
  protocol    = each.value.protocol
  from_port   = each.value.from_port
  to_port     = each.value.to_port

  cidr_blocks = each.value.cidr_blocks
}

resource "aws_security_group_rule" "egress" {
  for_each = local.egress_rules_map

  type              = "egress"
  security_group_id = aws_security_group.this.id

  description = each.value.description
  protocol    = each.value.protocol
  from_port   = each.value.from_port
  to_port     = each.value.to_port

  cidr_blocks = each.value.cidr_blocks
}
