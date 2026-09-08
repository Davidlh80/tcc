provider "aws" {
  region = var.region
}

locals {
  ssh_rules = [
    for cidr in var.allow_ssh_from_cidrs : {
      description      = "Allow SSH from ${cidr}"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = [cidr]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
    }
  ]

  http_rules = [
    for cidr in var.allow_http_from_cidrs : {
      description      = "Allow HTTP from ${cidr}"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = [cidr]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
    }
  ]

  https_rules = [
    for cidr in var.allow_https_from_cidrs : {
      description      = "Allow HTTPS from ${cidr}"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = [cidr]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
    }
  ]

  custom_ingress = [
    for r in var.additional_ingress_rules : {
      description      = r.description
      from_port        = r.from_port
      to_port          = r.to_port
      protocol         = r.protocol
      cidr_blocks      = r.cidr_blocks
      ipv6_cidr_blocks = r.ipv6_cidr_blocks
      prefix_list_ids  = r.prefix_list_ids
    }
  ]

  ingress_rules = concat(local.ssh_rules, local.http_rules, local.https_rules, local.custom_ingress)
}

resource "aws_security_group" "this" {
  name                   = var.name
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  # Secure default: no implicit outbound rule (AWS default is allow-all).
  # We explicitly set zero egress rules here and manage any egress via
  # aws_vpc_security_group_egress_rule resources below.
  egress = []

  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      description      = ingress.value.description
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = length(ingress.value.cidr_blocks) > 0 ? ingress.value.cidr_blocks : null
      ipv6_cidr_blocks = length(ingress.value.ipv6_cidr_blocks) > 0 ? ingress.value.ipv6_cidr_blocks : null
      prefix_list_ids  = length(ingress.value.prefix_list_ids) > 0 ? ingress.value.prefix_list_ids : null
    }
  }

  tags = merge(
    {
      Name      = var.name
      ManagedBy = "terraform"
    },
    var.tags
  )
}

# Optional egress: allow all protocols to provided IPv4 CIDRs
resource "aws_vpc_security_group_egress_rule" "allow_all_ipv4" {
  for_each = var.allow_all_egress ? toset(var.egress_cidr_blocks) : []
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = each.value
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic to ${each.value}"
}

# Optional egress: allow all protocols to provided IPv6 CIDRs
resource "aws_vpc_security_group_egress_rule" "allow_all_ipv6" {
  for_each = var.allow_all_egress ? toset(var.egress_ipv6_cidr_blocks) : []
  security_group_id = aws_security_group.this.id
  cidr_ipv6         = each.value
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic to ${each.value}"
}
