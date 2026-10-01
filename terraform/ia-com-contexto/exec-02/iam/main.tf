locals {
  policy_name = "${var.environment}-${var.system}-iam-policy-${var.policy_name}"
  role_name   = "${var.environment}-${var.system}-iam-role-${var.policy_name}"

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

provider "aws" {
  region = var.region
}

data "aws_iam_policy_document" "trust" {
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

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "AllowConfiguredActionsOnConfiguredResources"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_role" "this" {
  name                 = local.role_name
  description          = "Role gerenciada via Terraform para o sistema ${var.system} (${var.environment})."
  assume_role_policy   = data.aws_iam_policy_document.trust.json
  max_session_duration = 3600

  tags = local.tags
}

resource "aws_iam_policy" "this" {
  name        = local.policy_name
  description = var.policy_description
  policy      = data.aws_iam_policy_document.this.json

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
