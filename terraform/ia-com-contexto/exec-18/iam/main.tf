locals {
  role_name   = "${var.environment}-${var.system}-iam-role-${var.policy_name}"
  policy_name = "${var.environment}-${var.system}-iam-policy-${var.policy_name}"

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

data "aws_iam_policy_document" "trust" {
  statement {
    sid     = "AssumeRoleTrustedPrincipalOnly"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.trusted_principal_arn]
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = local.role_name
  assume_role_policy   = data.aws_iam_policy_document.trust.json
  max_session_duration = 3600

  tags = local.tags
}

data "aws_iam_policy_document" "permissions" {
  statement {
    sid       = "LeastPrivilegeAllow"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_name
  description = "Policy de menor privilegio (${local.policy_name}), gerenciada via Terraform."
  policy      = data.aws_iam_policy_document.permissions.json

  tags = local.tags

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "Nao e permitida uma statement combinando Action \"*\" com Resource \"*\"."
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
