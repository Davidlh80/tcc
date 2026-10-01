provider "aws" {
  region = var.region
}

locals {
  name_prefix      = "${var.environment}-${var.system}"
  policy_full_name = "${local.name_prefix}-iam-policy-${var.policy_name}"
  role_full_name   = "${local.name_prefix}-iam-role-${var.policy_name}"

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

data "aws_iam_policy_document" "permissions" {
  statement {
    sid       = "AllowedActionsOnAllowedResources"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

data "aws_iam_policy_document" "trust" {
  statement {
    sid     = "AllowAssumeRoleFromTrustedPrincipal"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.trusted_principal_arn]
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_full_name
  description = "Policy de menor privilegio para ${var.policy_name} no sistema ${var.system} (${var.environment})."
  policy      = data.aws_iam_policy_document.permissions.json
  tags        = local.tags

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "Nao e permitido combinar Action \"*\" com Resource \"*\" na mesma statement."
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = local.role_full_name
  description          = "Role assumida por ${var.trusted_principal_arn} para o sistema ${var.system} (${var.environment})."
  assume_role_policy   = data.aws_iam_policy_document.trust.json
  max_session_duration = 3600
  tags                 = local.tags

  lifecycle {
    precondition {
      condition     = var.trusted_principal_arn != "*"
      error_message = "O principal confiavel (trusted_principal_arn) nao pode ser \"*\"."
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
