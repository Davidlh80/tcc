provider "aws" {
  region = var.aws_region
}

locals {
  tags = merge(
    {
      Name      = var.name
      ManagedBy = "Terraform"
    },
    var.tags
  )

  rules_map = { for i, r in var.rules : tostring(i) => r }
}

resource "aws_security_group" "this" {
  name                   = var.name
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  tags = local.tags
}

resource "aws_security_group_rule" "this" {
  for_each = local.rules_map

  security_group_id = aws_security_group.this.id
  type              = each.value.type

  description = try(each.value.description, null)
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = lower(each.value.protocol)

  cidr_blocks      = length(try(each.value.cidr_blocks, [])) > 0 ? each.value.cidr_blocks : null
  ipv6_cidr_blocks = length(try(each.value.ipv6_cidr_blocks, [])) > 0 ? each.value.ipv6_cidr_blocks : null
  prefix_list_ids  = length(try(each.value.prefix_list_ids, [])) > 0 ? each.value.prefix_list_ids : null

  source_security_group_id = try(each.value.source_security_group_id, null)
  self                     = try(each.value.self, false)
}
