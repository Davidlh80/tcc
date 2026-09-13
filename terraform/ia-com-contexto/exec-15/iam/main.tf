terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.region
}

locals {
  policy_full_name = "${var.environment}-${var.system}-iam-${var.policy_name}"

  common_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }
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
  description = "Custom least-privilege IAM policy for ${var.system} (${var.environment})."
  policy      = data.aws_iam_policy_document.this.json

  tags = merge(local.common_tags, var.additional_tags)

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "A combinacao de Action = \"*\" com Resource = \"*\" na mesma statement nao e permitida por politica organizacional."
    }
  }
}
