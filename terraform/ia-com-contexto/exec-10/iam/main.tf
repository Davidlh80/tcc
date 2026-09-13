provider "aws" {
  region = var.region
}

locals {
  resource_name = "${var.environment}-${var.system}-iam-${var.policy_name}"

  default_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags = merge(local.default_tags, var.additional_tags)
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
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "A combinacao de Action \"*\" com Resource \"*\" na mesma statement nao e permitida."
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = local.resource_name
  description = var.policy_description
  policy      = data.aws_iam_policy_document.this.json

  tags = local.tags
}
