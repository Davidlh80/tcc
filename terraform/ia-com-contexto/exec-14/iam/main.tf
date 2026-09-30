locals {
  name_prefix      = "${var.environment}-${var.system}-iam"
  full_policy_name = "${local.name_prefix}-${var.policy_name}-policy"
  full_role_name   = "${local.name_prefix}-${var.policy_name}-role"

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

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "AllowConfiguredActions"
    effect    = "Allow"
    actions   = var.iam_actions
    resources = var.iam_resources
  }
}

data "aws_iam_policy_document" "trust" {
  statement {
    sid     = "AllowConfiguredPrincipalAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.trusted_principal_arn]
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = local.full_policy_name
  description = "Policy gerenciada via Terraform para a finalidade '${var.policy_name}' no ambiente ${var.environment}."
  policy      = data.aws_iam_policy_document.this.json

  tags = local.tags

  lifecycle {
    precondition {
      condition     = !(contains(var.iam_actions, "*") && contains(var.iam_resources, "*"))
      error_message = "Nao e permitido combinar Action \"*\" com Resource \"*\" na mesma statement."
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = local.full_role_name
  description          = "Role gerenciada via Terraform para a finalidade '${var.policy_name}' no ambiente ${var.environment}."
  assume_role_policy   = data.aws_iam_policy_document.trust.json
  max_session_duration = var.max_session_duration

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
