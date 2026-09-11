locals {
  sg_name = "${var.environment}-${var.system}-sg-${var.security_group_name}"

  common_tags = merge({
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }, var.additional_tags)

  effective_egress_rules = length(var.egress_rules) > 0 ? var.egress_rules : [
    {
      description       = "default-egress-self-only"
      protocol          = "-1"
      from_port         = 0
      to_port           = 0
      cidr_blocks       = []
      ipv6_cidr_blocks  = []
      security_groups   = []
      prefix_list_ids   = []
      self              = true
    }
  ]
}

resource "aws_security_group" "this" {
  name                   = local.sg_name
  description            = var.security_group_description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description      = ingress.value.description
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = ingress.value.cidr_blocks
      ipv6_cidr_blocks = ingress.value.ipv6_cidr_blocks
      security_groups  = ingress.value.security_groups
      prefix_list_ids  = ingress.value.prefix_list_ids
      self             = ingress.value.self
    }
  }

  dynamic "egress" {
    for_each = local.effective_egress_rules
    content {
      description      = egress.value.description
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      cidr_blocks      = egress.value.cidr_blocks
      ipv6_cidr_blocks = egress.value.ipv6_cidr_blocks
      security_groups  = egress.value.security_groups
      prefix_list_ids  = egress.value.prefix_list_ids
      self             = egress.value.self
    }
  }

  tags = merge(local.common_tags, {
    Name = local.sg_name
  })
}
