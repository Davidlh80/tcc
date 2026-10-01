locals {
  name_prefix = "${var.environment}-${var.system}"
  policy_name = "${local.name_prefix}-iam-policy-${var.policy_name}"
  role_name   = "${local.name_prefix}-iam-role-${var.policy_name}"

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

# Trust policy (assume role policy) restrita a um unico principal configuravel.
data "aws_iam_policy_document" "assume_role" {
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

# Permissoes da policy restritas as acoes e recursos informados por variavel.
data "aws_iam_policy_document" "permissions" {
  statement {
    sid       = "AllowConfiguredActionsOnConfiguredResources"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

# Guarda redundante em tempo de plan/validate contra Action:"*" combinado com Resource:"*".
check "no_full_wildcard_statement" {
  assert {
    condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
    error_message = "Nao e permitido combinar Action: \"*\" com Resource: \"*\" na mesma statement."
  }
}

resource "aws_iam_role" "this" {
  name                 = local.role_name
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  max_session_duration = 3600

  tags = local.tags
}

resource "aws_iam_policy" "this" {
  name   = local.policy_name
  policy = data.aws_iam_policy_document.permissions.json

  tags = local.tags
}

# Garante que a policy nunca fica "solta": sempre anexada a role criada acima.
resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
