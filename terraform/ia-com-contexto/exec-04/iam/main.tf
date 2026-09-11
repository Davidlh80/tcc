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

  tags = merge(var.additional_tags, local.mandatory_tags)
}

data "aws_iam_policy_document" "allow_configured" {
  statement {
    sid     = "AllowConfiguredActions"
    effect  = "Allow"
    actions = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_full_name
  description = coalesce(var.policy_description, "IAM policy for ${var.system} (${var.environment}) allowing only configured actions and resources.")
  policy      = data.aws_iam_policy_document.allow_configured.json
  tags        = local.tags
}
