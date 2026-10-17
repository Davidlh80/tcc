locals {
  security_group_names = {
    backend = "${var.environment}-${var.system}-sg-${var.security_group_purposes.backend}"
    rds     = "${var.environment}-${var.system}-sg-${var.security_group_purposes.rds}"
    redis   = "${var.environment}-${var.system}-sg-${var.security_group_purposes.redis}"
  }

  backend_tags = merge(
    var.additional_tags,
    var.required_tags,
    {
      Environment = var.environment
      Owner       = var.owner
      Name        = local.security_group_names.backend
    }
  )

  rds_tags = merge(
    var.additional_tags,
    var.required_tags,
    {
      Environment = var.environment
      Owner       = var.owner
      Name        = local.security_group_names.rds
    }
  )

  redis_tags = merge(
    var.additional_tags,
    var.required_tags,
    {
      Environment = var.environment
      Owner       = var.owner
      Name        = local.security_group_names.redis
    }
  )
}

resource "aws_security_group" "backend" {
  name_prefix = "${local.security_group_names.backend}-"
  description = "Security group for the EC2 backend."
  vpc_id      = var.vpc_id
  tags        = local.backend_tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "rds" {
  name_prefix = "${local.security_group_names.rds}-"
  description = "Security group for the relational database."
  vpc_id      = var.vpc_id
  tags        = local.rds_tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "redis" {
  name_prefix = "${local.security_group_names.redis}-"
  description = "Security group for the Redis cache."
  vpc_id      = var.vpc_id
  tags        = local.redis_tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_default_security_group" "this" {
  count = var.manage_default_security_group ? 1 : 0

  vpc_id = var.vpc_id
  tags = merge(
    var.additional_tags,
    var.required_tags,
    {
      Environment = var.environment
      Owner       = var.owner
      Name        = "${var.environment}-${var.system}-sg-default"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "backend_http" {
  for_each = toset(var.http_ingress_cidrs)

  security_group_id = aws_security_group.backend.id
  description       = "Allow HTTP traffic to the backend from configured IPv4 CIDRs."
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = each.value
}

resource "aws_vpc_security_group_ingress_rule" "backend_https" {
  for_each = toset(var.https_ingress_cidrs)

  security_group_id = aws_security_group.backend.id
  description       = "Allow HTTPS traffic to the backend from configured IPv4 CIDRs."
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = each.value
}

resource "aws_vpc_security_group_ingress_rule" "backend_ssh" {
  for_each = toset(var.ssh_cidrs)

  security_group_id = aws_security_group.backend.id
  description       = "Allow SSH from an explicitly authorized IPv4 address."
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = each.value
}

resource "aws_vpc_security_group_egress_rule" "backend_https" {
  for_each = toset(var.https_egress_cidrs)

  security_group_id = aws_security_group.backend.id
  description       = "Allow backend HTTPS egress."
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = each.value
}

resource "aws_vpc_security_group_egress_rule" "backend_rds" {
  security_group_id            = aws_security_group.backend.id
  referenced_security_group_id = aws_security_group.rds.id
  description                  = "Allow backend traffic to the relational database."
  ip_protocol                  = "tcp"
  from_port                    = var.rds_port
  to_port                      = var.rds_port
}

resource "aws_vpc_security_group_egress_rule" "backend_redis" {
  security_group_id            = aws_security_group.backend.id
  referenced_security_group_id = aws_security_group.redis.id
  description                  = "Allow backend traffic to the Redis cache."
  ip_protocol                  = "tcp"
  from_port                    = var.redis_port
  to_port                      = var.redis_port
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_backend" {
  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = aws_security_group.backend.id
  description                  = "Allow database traffic from the backend."
  ip_protocol                  = "tcp"
  from_port                    = var.rds_port
  to_port                      = var.rds_port
}

resource "aws_vpc_security_group_ingress_rule" "redis_from_backend" {
  security_group_id            = aws_security_group.redis.id
  referenced_security_group_id = aws_security_group.backend.id
  description                  = "Allow Redis traffic from the backend."
  ip_protocol                  = "tcp"
  from_port                    = var.redis_port
  to_port                      = var.redis_port
}
