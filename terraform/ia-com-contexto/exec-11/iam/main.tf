locals {
  name_prefix = "${var.environment}-${var.system}"
  policy_name = "${local.name_prefix}-iam-${var.policy_name}"
  role_name   = "${local.name_prefix}-iam-${var.policy_name}-role"

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
    sid     = "AllowConfiguredPrincipalAssumeRole"
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
  description          = "IAM Role para ${var.policy_name}, gerenciada via Terraform."
  assume_role_policy    = data.aws_iam_policy_document.trust.json
  max_session_duration = 3600

  tags = local.tags
}

resource "aws_iam_policy" "this" {
  name        = local.policy_name
  description = "IAM Policy de menor privilegio para ${var.policy_name}, gerenciada via Terraform."
  policy      = data.aws_iam_policy_document.this.json

  tags = local.tags

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "Nao e permitido combinar Action \"*\" com Resource \"*\" na mesma statement."
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
