provider "aws" {
  region = var.region
}

locals {
  name_prefix = "${var.environment}-${var.system}-iam-${var.policy_name}"

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
    sid     = "AllowTrustedPrincipalAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.trusted_principal_arn]
    }
  }
}

data "aws_iam_policy_document" "permissions" {
  statement {
    sid       = "AllowConfiguredActionsOnConfiguredResources"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_role" "this" {
  name                 = "${local.name_prefix}-role"
  description          = "Role de menor privilegio para ${var.system} (${var.environment}) - finalidade: ${var.policy_name}"
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  max_session_duration = 3600

  tags = local.tags
}

resource "aws_iam_policy" "this" {
  name        = "${local.name_prefix}-policy"
  description = "Policy de menor privilegio para ${var.system} (${var.environment}) - finalidade: ${var.policy_name}"
  policy      = data.aws_iam_policy_document.permissions.json

  tags = local.tags

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "A combinacao de Action \"*\" com Resource \"*\" na mesma statement nao e permitida."
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
