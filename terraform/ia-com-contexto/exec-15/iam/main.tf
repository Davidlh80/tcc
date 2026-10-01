locals {
  name_prefix = "${var.environment}-${var.system}-iam-${var.purpose}"
  policy_name = local.name_prefix
  role_name   = "${local.name_prefix}-role"

  tags = merge(
    {
      Project     = "tcc-iac-ia"
      Environment = var.environment
      ManagedBy   = "terraform"
      Owner       = "devops"
      CostCenter  = "academic-research"
    },
    var.additional_tags
  )
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AllowConfiguredPrincipalToAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.trusted_principal_arn]
    }
  }
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid       = "AllowConfiguredActionsOnConfiguredResources"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_name
  description = var.policy_description
  policy      = data.aws_iam_policy_document.policy.json
  tags        = local.tags

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "Nao e permitido combinar Action \"*\" com Resource \"*\" na mesma statement."
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = local.role_name
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  max_session_duration  = var.max_session_duration
  tags                  = local.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
