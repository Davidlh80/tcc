provider "aws" {
  region = var.region
}

locals {
  default_egress = [
    {
      description      = "Allow all IPv4 egress"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
    },
    {
      description      = "Allow all IPv6 egress"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = []
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
    }
  ]

  computed_egress = length(var.egress_rules) > 0 ? var.egress_rules : (var.enable_default_egress ? local.default_egress : [])

  merged_tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}

resource "aws_security_group" "this" {
  name                   = var.name
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol

      cidr_blocks      = length(ingress.value.cidr_blocks) > 0 ? ingress.value.cidr_blocks : null
      ipv6_cidr_blocks = length(ingress.value.ipv6_cidr_blocks) > 0 ? ingress.value.ipv6_cidr_blocks : null
      prefix_list_ids  = length(ingress.value.prefix_list_ids) > 0 ? ingress.value.prefix_list_ids : null
      security_groups  = length(ingress.value.security_groups) > 0 ? ingress.value.security_groups : null
      self             = ingress.value.self
    }
  }

  dynamic "egress" {
    for_each = local.computed_egress
    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol

      cidr_blocks      = length(egress.value.cidr_blocks) > 0 ? egress.value.cidr_blocks : null
      ipv6_cidr_blocks = length(egress.value.ipv6_cidr_blocks) > 0 ? egress.value.ipv6_cidr_blocks : null
      prefix_list_ids  = length(egress.value.prefix_list_ids) > 0 ? egress.value.prefix_list_ids : null
    }
  }

  tags = local.merged_tags

  lifecycle {
    create_before_destroy = true
  }
}
