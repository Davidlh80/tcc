provider "aws" {
  region = var.region
}

locals {
  # Nome do recurso seguindo o padrão: <ambiente>-<sistema>-<recurso>-<finalidade>
  security_group_full_name = "${var.environment}-${var.system}-sg-${var.security_group_name}"

  # Tags obrigatórias + tags adicionais (as obrigatórias prevalecem)
  common_tags = merge(
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

resource "aws_security_group" "this" {
  name        = local.security_group_full_name
  description = var.security_group_description
  vpc_id      = var.vpc_id

  revoke_rules_on_delete = true

  # Regras de entrada
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description      = ingress.value.description
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = ingress.value.cidr_blocks
      ipv6_cidr_blocks = ingress.value.ipv6_cidr_blocks
      prefix_list_ids  = ingress.value.prefix_list_ids
      security_groups  = ingress.value.security_groups
      self             = ingress.value.self
    }
  }

  # Regras de saída (declaradas explicitamente, sem liberação irrestrita por padrão)
  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description      = egress.value.description
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      cidr_blocks      = egress.value.cidr_blocks
      ipv6_cidr_blocks = egress.value.ipv6_cidr_blocks
      prefix_list_ids  = egress.value.prefix_list_ids
      security_groups  = egress.value.security_groups
      self             = egress.value.self
    }
  }

  tags = local.common_tags
}
