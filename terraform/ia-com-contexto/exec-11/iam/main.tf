provider "aws" {
  region = var.region
}

locals {
  policy_full_name = "${var.environment}-${var.system}-iam-${var.policy_name}"

  mandatory_tags = {
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

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "A combinacao de Action = \"*\" com Resource = \"*\" na mesma statement nao e permitida por esta organizacao."
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_full_name
  description = var.description
  policy      = data.aws_iam_policy_document.this.json

  tags = merge(local.mandatory_tags, var.additional_tags)
}
