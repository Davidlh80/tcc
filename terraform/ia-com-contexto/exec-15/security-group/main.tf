provider "aws" {
  region = var.region
}

locals {
  sg_resource_name = "${var.environment}-${var.system}-sg-${var.security_group_name}"

  sg_description = coalesce(
    var.security_group_description,
    "Security Group ${local.sg_resource_name} gerenciado por Terraform"
  )

  mandatory_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  merged_tags = merge(
    var.additional_tags,
    local.mandatory_tags,
    { Name = local.sg_resource_name }
  )
}

resource "aws_security_group" "this" {
  name                   = local.sg_resource_name
  description            = local.sg_description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  tags = local.merged_tags
}

resource "aws_security_group_rule" "ingress" {
  for_each = { for idx, rule in var.ingress_rules : idx => rule }

  type                     = "ingress"
  security_group_id        = aws_security_group.this.id
  description              = trim(each.value.description)
  protocol                 = each.value.protocol
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  cidr_blocks              = try(each.value.cidr_blocks, [])
  ipv6_cidr_blocks         = try(each.value.ipv6_cidr_blocks, [])
  prefix_list_ids          = try(each.value.prefix_list_ids, [])
  source_security_group_id = try(each.value.source_security_group_id, null)
  self                     = try(each.value.self, false)

  lifecycle {
    precondition {
      condition = (
        (
          (length(each.value.cidr_blocks) > 0 ? 1 : 0) +
          (length(each.value.ipv6_cidr_blocks) > 0 ? 1 : 0) +
          (length(each.value.prefix_list_ids) > 0 ? 1 : 0) +
          (try(each.value.self, false) ? 1 : 0) +
          (try(each.value.source_security_group_id, null) != null ? 1 : 0)
        ) == 1
      )
      error_message = "Cada regra de ingress deve especificar exatamente uma origem entre: cidr_blocks, ipv6_cidr_blocks, prefix_list_ids, self ou source_security_group_id."
    }
    precondition {
      condition = !(
        contains(try(each.value.cidr_blocks, []), "0.0.0.0/0") ||
        contains(try(each.value.ipv6_cidr_blocks, []), "::/0")
      ) || (
        lower(each.value.protocol) == "tcp" &&
        each.value.from_port == 443 &&
        each.value.to_port == 443
      )
      error_message = "Ingress: 0.0.0.0/0 ou ::/0 só são permitidos para tcp/443."
    }
    precondition {
      condition     = length(trim(each.value.description)) > 0
      error_message = "Toda regra de ingress deve conter uma descrição não vazia."
    }
  }
}

resource "aws_security_group_rule" "egress" {
  for_each = { for idx, rule in var.egress_rules : idx => rule }

  type                          = "egress"
  security_group_id             = aws_security_group.this.id
  description                   = trim(each.value.description)
  protocol                      = each.value.protocol
  from_port                     = each.value.from_port
  to_port                       = each.value.to_port
  cidr_blocks                   = try(each.value.cidr_blocks, [])
  ipv6_cidr_blocks              = try(each.value.ipv6_cidr_blocks, [])
  prefix_list_ids               = try(each.value.prefix_list_ids, [])
  destination_security_group_id = try(each.value.destination_security_group_id, null)

  lifecycle {
    precondition {
      condition = (
        (
          (length(each.value.cidr_blocks) > 0 ? 1 : 0) +
          (length(each.value.ipv6_cidr_blocks) > 0 ? 1 : 0) +
          (length(each.value.prefix_list_ids) > 0 ? 1 : 0) +
          (try(each.value.destination_security_group_id, null) != null ? 1 : 0)
        ) == 1
      )
      error_message = "Cada regra de egress deve especificar exatamente um destino entre: cidr_blocks, ipv6_cidr_blocks, prefix_list_ids ou destination_security_group_id."
    }
    precondition {
      condition = !(
        contains(try(each.value.cidr_blocks, []), "0.0.0.0/0") ||
        contains(try(each.value.ipv6_cidr_blocks, []), "::/0")
      ) || (
        lower(each.value.protocol) == "tcp" &&
        each.value.from_port == 443 &&
        each.value.to_port == 443
      )
      error_message = "Egress: 0.0.0.0/0 ou ::/0 só são permitidos para tcp/443."
    }
    precondition {
      condition     = length(trim(each.value.description)) > 0
      error_message = "Toda regra de egress deve conter uma descrição não vazia."
    }
  }
}
