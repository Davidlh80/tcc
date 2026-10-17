locals {
  security_group_name = "${var.environment}-${var.security_group_name}"
  security_group_tags = merge(var.additional_tags, {
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = "tcc-iac-p31"
    Name        = local.security_group_name
  })

  ingress_rules = {
    for rule in setproduct(toset(var.allowed_ports), toset(var.allowed_cidrs)) :
    "${rule[0]}-${rule[1]}" => {
      port = rule[0]
      cidr = rule[1]
    }
  }

  egress_rules = {
    for index, rule in var.egress_rules : tostring(index) => rule
  }
}

resource "aws_security_group" "workload" {
  name        = local.security_group_name
  description = var.description
  vpc_id      = var.vpc_id
  egress      = []
  tags        = local.security_group_tags
}

resource "aws_vpc_security_group_ingress_rule" "configured" {
  for_each = local.ingress_rules

  security_group_id = aws_security_group.workload.id
  description       = "TCP ${each.value.port} from configured IPv4 CIDR"
  ip_protocol       = "tcp"
  from_port         = each.value.port
  to_port           = each.value.port
  cidr_ipv4         = each.value.cidr
}

resource "aws_vpc_security_group_egress_rule" "configured" {
  for_each = local.egress_rules

  security_group_id = aws_security_group.workload.id
  description       = each.value.description
  ip_protocol       = "tcp"
  from_port         = each.value.port
  to_port           = each.value.port
  cidr_ipv4         = each.value.cidr_ipv4
}
