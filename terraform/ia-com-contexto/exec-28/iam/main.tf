locals {
  name_prefix = "${var.environment}-${var.system}-iam-${var.policy_name}"

  mandatory_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags = merge(local.mandatory_tags, var.additional_tags)

  has_wildcard_action  = contains(var.allowed_actions, "*")
  has_wildcard_resource = contains(var.allowed_resources, "*")
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AllowConfiguredPrincipalToAssume"
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

resource "aws_iam_policy" "this" {
  name        = local.name_prefix
  description = "Policy de menor privilegio gerenciada via Terraform para o sistema ${var.system} no ambiente ${var.environment}."
  policy      = data.aws_iam_policy_document.permissions.json

  tags = local.tags

  lifecycle {
    precondition {
      condition     = !(local.has_wildcard_action && local.has_wildcard_resource)
      error_message = "Nao e permitido combinar Action = \"*\" com Resource = \"*\" na mesma statement da policy."
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = "${local.name_prefix}-role"
  description          = "IAM Role de menor privilegio para o sistema ${var.system} no ambiente ${var.environment}."
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  max_session_duration = 3600

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
