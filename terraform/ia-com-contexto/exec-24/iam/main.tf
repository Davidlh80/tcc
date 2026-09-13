locals {
  policy_full_name = "${var.environment}-${var.system}-iam-${var.policy_name}"
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "AllowConfiguredActions"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_full_name
  description = var.policy_description
  policy      = data.aws_iam_policy_document.this.json

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

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "A policy nao pode combinar Action \"*\" com Resource \"*\" na mesma statement."
    }
  }
}
