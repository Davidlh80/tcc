provider "aws" {
  region = var.region
}

locals {
  resource_name = "${var.environment}-${var.system}-sg-${var.security_group_name}"

  mandatory_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags = merge(local.mandatory_tags, var.additional_tags)
}

resource "aws_security_group" "this" {
  name                   = local.resource_name
  description            = var.security_group_description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  # Segurança por padrão: nenhuma regra inline; regras serão gerenciadas
  # explicitamente via aws_security_group_rule abaixo. Estas listas vazias
  # garantem remoção das regras padrão "allow all" criadas pela AWS.
  ingress = []
  egress  = []

  tags = local.tags
}

# Regras de ingress
resource "aws_security_group_rule" "ingress" {
  for_each          = { for idx, r in var.ingress_rules : tostring(idx) => r }
  type              = "ingress"
  security_group_id = aws_security_group.this.id

  description = each.value.description
  protocol    = lower(each.value.protocol)
  from_port   = lower(each.value.protocol) == "-1" ? 0 : each.value.from_port
  to_port     = lower(each.value.protocol) == "-1" ? 0 : each.value.to_port

  cidr_blocks       = length(each.value.cidr_blocks) > 0 ? each.value.cidr_blocks : null
  ipv6_cidr_blocks  = length(each.value.ipv6_cidr_blocks) > 0 ? each.value.ipv6_cidr_blocks : null
}

# Regras de egress explícitas (sem liberação irrestrita por padrão)
resource "aws_security_group_rule" "egress" {
  for_each          = { for idx, r in var.egress_rules : tostring(idx) => r }
  type              = "egress"
  security_group_id = aws_security_group.this.id

  description = each.value.description
  protocol    = lower(each.value.protocol)
  from_port   = lower(each.value.protocol) == "-1" ? 0 : each.value.from_port
  to_port     = lower(each.value.protocol) == "-1" ? 0 : each.value.to_port

  cidr_blocks       = length(each.value.cidr_blocks) > 0 ? each.value.cidr_blocks : null
  ipv6_cidr_blocks  = length(each.value.ipv6_cidr_blocks) > 0 ? each.value.ipv6_cidr_blocks : null
}
