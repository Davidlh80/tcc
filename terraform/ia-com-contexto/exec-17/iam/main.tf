locals {
  name = "${var.environment}-${var.system}-iam-${var.policy_name}"

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

  has_wildcard_action   = contains(var.allowed_actions, "*")
  has_wildcard_resource = contains(var.allowed_resources, "*")
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "AllowConfiguredActions"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }

  lifecycle {
    precondition {
      condition     = !(local.has_wildcard_action && local.has_wildcard_resource)
      error_message = "Nao e permitido combinar Action = \"*\" com Resource = \"*\" na mesma statement."
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = local.name
  description = var.policy_description
  policy      = data.aws_iam_policy_document.this.json

  tags = local.tags
}
