data "aws_iam_policy_document" "assume_role" {
  dynamic "statement" {
    for_each = length(var.trusted_service_principals) > 0 ? [1] : []
    content {
      sid     = "TrustedServicePrincipals"
      effect  = "Allow"
      actions = ["sts:AssumeRole"]

      principals {
        type        = "Service"
        identifiers = var.trusted_service_principals
      }
    }
  }

  dynamic "statement" {
    for_each = length(var.trusted_account_arns) > 0 ? [1] : []
    content {
      sid     = "TrustedAccountPrincipals"
      effect  = "Allow"
      actions = ["sts:AssumeRole"]

      principals {
        type        = "AWS"
        identifiers = var.trusted_account_arns
      }

      dynamic "condition" {
        for_each = var.external_id != "" ? [1] : []
        content {
          test     = "StringEquals"
          variable = "sts:ExternalId"
          values   = [var.external_id]
        }
      }
    }
  }
}

resource "aws_iam_role" "this" {
  name                  = "${var.name_prefix}-role"
  description           = "Role gerenciada via Terraform para ${var.name_prefix}, com confianca restrita aos principais configurados."
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  max_session_duration  = var.max_session_duration
  permissions_boundary  = var.permissions_boundary_arn
  force_detach_policies = true

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-role"
  })
}

data "aws_iam_policy_document" "permissions" {
  statement {
    sid       = "AllowConfiguredActions"
    effect    = "Allow"
    actions   = var.policy_actions
    resources = var.policy_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = "${var.name_prefix}-policy"
  description = "Politica de minimo privilegio anexada a role ${var.name_prefix}-role. Sem principais soltos; uso exclusivo via role attachment."
  policy      = data.aws_iam_policy_document.permissions.json

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-policy"
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
