data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AllowSpecificPrincipalAssumeRole"
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
    sid       = "LeastPrivilegeAccess"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

locals {
  policy_full_name = "${var.environment}-${var.system}-iam-${var.policy_name}"
  role_full_name   = "${var.environment}-${var.system}-iam-role-${var.policy_name}"

  mandatory_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags = merge(local.mandatory_tags, var.additional_tags)
}

resource "aws_iam_policy" "this" {
  name        = local.policy_full_name
  description = var.policy_description
  policy      = data.aws_iam_policy_document.policy.json

  tags = local.tags

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "A combinacao de Action \"*\" com Resource \"*\" na mesma statement nao e permitida."
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = local.role_full_name
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  max_session_duration = var.max_session_duration

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
