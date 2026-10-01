locals {
  policy_full_name = "${var.environment}-${var.system}-iam-${var.policy_name}"
  role_full_name    = "${var.environment}-${var.system}-iam-${var.role_purpose}"

  mandatory_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags = merge(local.mandatory_tags, var.additional_tags)
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AllowConfiguredPrincipalToAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.trusted_principal_arns
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = local.role_full_name
  path                 = var.role_path
  description          = var.role_description
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  max_session_duration = var.max_session_duration

  tags = local.tags

  lifecycle {
    precondition {
      condition     = length(var.trusted_principal_arns) > 0 && !contains(var.trusted_principal_arns, "*")
      error_message = "trusted_principal_arns nao pode ser vazio nem conter '*'. Informe ARNs especificos de principals confiaveis."
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
  path        = var.policy_path
  description = var.policy_description
  policy      = data.aws_iam_policy_document.this.json

  tags = local.tags

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "Nao e permitido combinar Action \"*\" com Resource \"*\" na mesma statement. Informe acoes e recursos especificos."
    }
    precondition {
      condition     = length(var.allowed_actions) > 0 && length(var.allowed_resources) > 0
      error_message = "allowed_actions e allowed_resources devem conter ao menos um item cada."
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
