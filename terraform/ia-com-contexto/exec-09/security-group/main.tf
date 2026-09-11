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

  # Inline representation of rules to ensure explicit egress (egress = []) when none provided.
  ingress_rules_normalized = [
    for r in var.ingress_rules : {
      description      = r.description
      from_port        = r.from_port
      to_port          = r.to_port
      protocol         = r.protocol
      cidr_blocks      = r.cidr_blocks
      ipv6_cidr_blocks = r.ipv6_cidr_blocks
      security_groups  = r.security_groups
      prefix_list_ids  = r.prefix_list_ids
    }
  ]

  egress_rules_normalized = [
    for r in var.egress_rules : {
      description      = r.description
      from_port        = r.from_port
      to_port          = r.to_port
      protocol         = r.protocol
      cidr_blocks      = r.cidr_blocks
      ipv6_cidr_blocks = r.ipv6_cidr_blocks
      security_groups  = r.security_groups
      prefix_list_ids  = r.prefix_list_ids
    }
  ]
}

resource "aws_security_group" "this" {
  name        = local.sg_name
  description = var.security_group_description
  vpc_id      = var.vpc_id

  # Explicitly set rules using inline representations.
  # When lists are empty, this keeps the SG with no implicit "allow all" egress.
  ingress = local.ingress_rules_normalized
  egress  = local.egress_rules_normalized

  revoke_rules_on_delete = true

  tags = merge(
    var.additional_tags,
    local.mandatory_tags
  )
}
