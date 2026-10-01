data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AllowAssumeRoleByTrustedPrincipal"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [var.trusted_principal_service]
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = var.role_name
  path                 = var.path
  description          = var.role_description
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  max_session_duration = var.max_session_duration
  force_detach_policies = true

  tags = var.tags
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "AllowExplicitActionsOnExplicitResources"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.path
  description = var.policy_description
  policy      = data.aws_iam_policy_document.this.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
