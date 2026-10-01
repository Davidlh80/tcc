locals {
  mandatory_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags = merge(local.mandatory_tags, var.additional_tags)

  name_prefix      = "${var.environment}-${var.system}-iam"
  policy_full_name = "${local.name_prefix}-policy-${var.policy_name}"
  role_full_name   = "${local.name_prefix}-role-${var.policy_name}"
}

provider "aws" {
  region = var.region
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

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "AllowConfiguredActionsOnConfiguredResources"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_full_name
  description = "Policy de minimo privilegio gerenciada por Terraform para ${var.system} (${var.environment})."
  policy      = data.aws_iam_policy_document.this.json

  tags = local.tags

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "Nao e permitido combinar Action = \"*\" com Resource = \"*\" na mesma statement."
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = local.role_full_name
  description          = "Role de minimo privilegio gerenciada por Terraform para ${var.system} (${var.environment})."
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  max_session_duration = 3600

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
