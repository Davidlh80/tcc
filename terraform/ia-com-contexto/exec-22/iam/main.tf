locals {
  name_prefix = "${var.environment}-${var.system}-iam-${var.policy_name}"
  role_name   = "${local.name_prefix}-role"
  policy_name = "${local.name_prefix}-policy"

  mandatory_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags = merge(local.mandatory_tags, var.additional_tags)

  has_wildcard_action   = contains(var.policy_actions, "*")
  has_wildcard_resource = contains(var.policy_resources, "*")
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AssumeRoleTrust"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.trusted_principal_arn]
    }
  }
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "AllowConfiguredActions"
    effect    = "Allow"
    actions   = var.policy_actions
    resources = var.policy_resources
  }
}

resource "aws_iam_role" "this" {
  name                 = local.role_name
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  max_session_duration = 3600

  tags = local.tags
}

resource "aws_iam_policy" "this" {
  name        = local.policy_name
  description = "Policy ${local.policy_name} com permissoes restritas as actions e recursos configurados por variavel"
  policy      = data.aws_iam_policy_document.this.json

  tags = local.tags

  lifecycle {
    precondition {
      condition     = !(local.has_wildcard_action && local.has_wildcard_resource)
      error_message = "Nao e permitido combinar Action \"*\" com Resource \"*\" na mesma statement."
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
