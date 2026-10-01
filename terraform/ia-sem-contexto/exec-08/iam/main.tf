data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AllowServicePrincipals"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = var.assume_role_service_principals
    }
  }

  dynamic "statement" {
    for_each = length(var.trusted_account_ids) > 0 ? [1] : []

    content {
      sid     = "AllowCrossAccountPrincipals"
      effect  = "Allow"
      actions = ["sts:AssumeRole"]

      principals {
        type        = "AWS"
        identifiers = [for account_id in var.trusted_account_ids : "arn:aws:iam::${account_id}:root"]
      }

      dynamic "condition" {
        for_each = var.external_id != null ? [var.external_id] : []

        content {
          test     = "StringEquals"
          variable = "sts:ExternalId"
          values   = [condition.value]
        }
      }
    }
  }
}

resource "aws_iam_role" "this" {
  name                  = var.role_name
  path                  = var.role_path
  description           = "Role assumida pelos principais configurados para executar acoes com permissoes minimas."
  assume_role_policy     = data.aws_iam_policy_document.assume_role.json
  max_session_duration  = var.max_session_duration
  force_detach_policies = var.force_detach_policies

  tags = var.tags
}

data "aws_iam_policy_document" "permissions" {
  statement {
    sid       = "AppPermissions"
    effect    = "Allow"
    actions   = var.policy_actions
    resources = var.policy_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.role_path
  description = "Policy gerenciada com o conjunto minimo de permissoes necessarias para ${var.role_name}."
  policy      = data.aws_iam_policy_document.permissions.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
