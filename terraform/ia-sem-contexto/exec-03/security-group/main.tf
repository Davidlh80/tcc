provider "aws" {
  region = var.aws_region
}

locals {
  # Tags padrao + tags adicionais do usuario (usuario pode sobrescrever se desejar)
  default_tags = merge(
    {
      Name      = var.name
      ManagedBy = "Terraform"
    },
    var.tags
  )

  # Expande regras de ingress para uma estrutura por destino (cidr, ipv6, prefix list, sg, self)
  ingress_expanded = flatten([
    for i, r in var.ingress_rules : concat(
      [
        for j, cidr in r.cidr_blocks : {
          key         = format("ing-cidr-%03d-%03d", i, j)
          description = coalesce(r.description, "ingress: " + cidr)
          protocol    = lower(r.protocol)
          from_port   = r.from_port
          to_port     = r.to_port
          cidr        = cidr
          ipv6        = null
          prefix      = null
          sg_id       = null
          self        = false
        }
      ],
      [
        for j, cidr6 in r.ipv6_cidr_blocks : {
          key         = format("ing-ipv6-%03d-%03d", i, j)
          description = coalesce(r.description, "ingress: " + cidr6)
          protocol    = lower(r.protocol)
          from_port   = r.from_port
          to_port     = r.to_port
          cidr        = null
          ipv6        = cidr6
          prefix      = null
          sg_id       = null
          self        = false
        }
      ],
      [
        for j, pl in r.prefix_list_ids : {
          key         = format("ing-pl-%03d-%03d", i, j)
          description = coalesce(r.description, "ingress: prefix-list " + pl)
          protocol    = lower(r.protocol)
          from_port   = r.from_port
          to_port     = r.to_port
          cidr        = null
          ipv6        = null
          prefix      = pl
          sg_id       = null
          self        = false
        }
      ],
      [
        for j, sg in r.security_group_ids : {
          key         = format("ing-sg-%03d-%03d", i, j)
          description = coalesce(r.description, "ingress: sg " + sg)
          protocol    = lower(r.protocol)
          from_port   = r.from_port
          to_port     = r.to_port
          cidr        = null
          ipv6        = null
          prefix      = null
          sg_id       = sg
          self        = false
        }
      ],
      r.self ? [{
        key         = format("ing-self-%03d", i)
        description = coalesce(r.description, "ingress: self")
        protocol    = lower(r.protocol)
        from_port   = r.from_port
        to_port     = r.to_port
        cidr        = null
        ipv6        = null
        prefix      = null
        sg_id       = null
        self        = true
      }] : []
    )
  ])

  # Expande regras de egress para uma estrutura por destino (cidr, ipv6, prefix list, sg, self)
  egress_expanded = flatten([
    for i, r in var.egress_rules : concat(
      [
        for j, cidr in r.cidr_blocks : {
          key         = format("eg-cidr-%03d-%03d", i, j)
          description = coalesce(r.description, "egress: " + cidr)
          protocol    = lower(r.protocol)
          from_port   = r.from_port
          to_port     = r.to_port
          cidr        = cidr
          ipv6        = null
          prefix      = null
          sg_id       = null
          self        = false
        }
      ],
      [
        for j, cidr6 in r.ipv6_cidr_blocks : {
          key         = format("eg-ipv6-%03d-%03d", i, j)
          description = coalesce(r.description, "egress: " + cidr6)
          protocol    = lower(r.protocol)
          from_port   = r.from_port
          to_port     = r.to_port
          cidr        = null
          ipv6        = cidr6
          prefix      = null
          sg_id       = null
          self        = false
        }
      ],
      [
        for j, pl in r.prefix_list_ids : {
          key         = format("eg-pl-%03d-%03d", i, j)
          description = coalesce(r.description, "egress: prefix-list " + pl)
          protocol    = lower(r.protocol)
          from_port   = r.from_port
          to_port     = r.to_port
          cidr        = null
          ipv6        = null
          prefix      = pl
          sg_id       = null
          self        = false
        }
      ],
      [
        for j, sg in r.security_group_ids : {
          key         = format("eg-sg-%03d-%03d", i, j)
          description = coalesce(r.description, "egress: sg " + sg)
          protocol    = lower(r.protocol)
          from_port   = r.from_port
          to_port     = r.to_port
          cidr        = null
          ipv6        = null
          prefix      = null
          sg_id       = sg
          self        = false
        }
      ],
      r.self ? [{
        key         = format("eg-self-%03d", i)
        description = coalesce(r.description, "egress: self")
        protocol    = lower(r.protocol)
        from_port   = r.from_port
        to_port     = r.to_port
        cidr        = null
        ipv6        = null
        prefix      = null
        sg_id       = null
        self        = true
      }] : []
    )
  ])
}

resource "aws_security_group" "this" {
  name                   = var.name
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete

  tags = local.default_tags
}

resource "aws_security_group_rule" "ingress" {
  for_each = { for item in local.ingress_expanded : item.key => item }

  type              = "ingress"
  security_group_id = aws_security_group.this.id
  description       = each.value.description
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port

  cidr_blocks      = each.value.cidr != null ? [each.value.cidr] : null
  ipv6_cidr_blocks = each.value.ipv6 != null ? [each.value.ipv6] : null
  prefix_list_ids  = each.value.prefix != null ? [each.value.prefix] : null

  source_security_group_id = each.value.sg_id
  self                     = each.value.self
}

resource "aws_security_group_rule" "egress" {
  for_each = { for item in local.egress_expanded : item.key => item }

  type              = "egress"
  security_group_id = aws_security_group.this.id
  description       = each.value.description
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port

  cidr_blocks      = each.value.cidr != null ? [each.value.cidr] : null
  ipv6_cidr_blocks = each.value.ipv6 != null ? [each.value.ipv6] : null
  prefix_list_ids  = each.value.prefix != null ? [each.value.prefix] : null

  referenced_security_group_id = each.value.sg_id
  self                         = each.value.self
}
