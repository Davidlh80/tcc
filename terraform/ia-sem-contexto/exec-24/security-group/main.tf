provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = merge(
    {
      Name      = var.name
      ManagedBy = "Terraform"
      Terraform = "true"
    },
    var.tags
  )

  custom_tcp_ipv4_pairs = flatten([
    for port in var.custom_tcp_ports : [
      for cidr in var.custom_tcp_cidrs : {
        port = port
        cidr = cidr
      }
    ]
  ])

  custom_tcp_ipv6_pairs = flatten([
    for port in var.custom_tcp_ports : [
      for cidr in var.custom_tcp_ipv6_cidrs : {
        port = port
        cidr = cidr
      }
    ]
  ])

  custom_tcp_ipv4_map = {
    for p in local.custom_tcp_ipv4_pairs :
    "${p.port}_${replace(p.cidr, "/", "-")}" => p
  }

  custom_tcp_ipv6_map = {
    for p in local.custom_tcp_ipv6_pairs :
    "${p.port}_${replace(p.cidr, "/", "-")}" => p
  }
}

resource "aws_security_group" "this" {
  name                   = var.name
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  # Bloqueia egress padrao; regras sao gerenciadas por recursos dedicados
  egress = []

  tags = local.common_tags
}

# Ingress SSH (22/TCP) por CIDR IPv4
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  for_each          = toset(var.allow_ssh_cidrs)
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = each.value
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  description       = "SSH from ${each.value}"
}

# Ingress HTTP (80/TCP) por CIDR IPv4
resource "aws_vpc_security_group_ingress_rule" "http" {
  for_each          = toset(var.allow_http_cidrs)
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = each.value
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  description       = "HTTP from ${each.value}"
}

# Ingress HTTPS (443/TCP) por CIDR IPv4
resource "aws_vpc_security_group_ingress_rule" "https" {
  for_each          = toset(var.allow_https_cidrs)
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = each.value
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  description       = "HTTPS from ${each.value}"
}

# Ingress TCP customizado por porta e CIDR IPv4
resource "aws_vpc_security_group_ingress_rule" "custom_tcp_ipv4" {
  for_each          = local.custom_tcp_ipv4_map
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = each.value.cidr
  ip_protocol       = "tcp"
  from_port         = each.value.port
  to_port           = each.value.port
  description       = "TCP ${each.value.port} from ${each.value.cidr}"
}

# Ingress TCP customizado por porta e CIDR IPv6
resource "aws_vpc_security_group_ingress_rule" "custom_tcp_ipv6" {
  for_each          = local.custom_tcp_ipv6_map
  security_group_id = aws_security_group.this.id
  cidr_ipv6         = each.value.cidr
  ip_protocol       = "tcp"
  from_port         = each.value.port
  to_port           = each.value.port
  description       = "TCP ${each.value.port} from ${each.value.cidr}"
}

# Ingress: trafego interno (self-reference) - todos protocolos/portas
resource "aws_vpc_security_group_ingress_rule" "self_all" {
  count                      = var.allow_self_all_ports ? 1 : 0
  security_group_id          = aws_security_group.this.id
  referenced_security_group_id = aws_security_group.this.id
  ip_protocol                = "-1"
  description                = "Allow all traffic within the same security group"
}

# Egress: permitir tudo IPv4
resource "aws_vpc_security_group_egress_rule" "all_ipv4" {
  count             = var.allow_all_egress ? 1 : 0
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all egress IPv4"
}

# Egress: permitir tudo IPv6 (opcional)
resource "aws_vpc_security_group_egress_rule" "all_ipv6" {
  count             = var.allow_all_egress_ipv6 ? 1 : 0
  security_group_id = aws_security_group.this.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
  description       = "Allow all egress IPv6"
}

# Egress customizado por CIDR IPv4
resource "aws_vpc_security_group_egress_rule" "custom_ipv4" {
  for_each          = toset(var.egress_cidrs)
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = each.value
  ip_protocol       = var.egress_protocol
  from_port         = var.egress_from_port
  to_port           = var.egress_to_port
  description       = "Custom egress to ${each.value}"
}

# Egress customizado por CIDR IPv6
resource "aws_vpc_security_group_egress_rule" "custom_ipv6" {
  for_each          = toset(var.egress_ipv6_cidrs)
  security_group_id = aws_security_group.this.id
  cidr_ipv6         = each.value
  ip_protocol       = var.egress_protocol
  from_port         = var.egress_from_port
  to_port           = var.egress_to_port
  description       = "Custom egress to ${each.value}"
}
