provider "aws" {
  region = var.region
}

locals {
  # Resource name following the organizational naming convention: <environment>-<system>-<resource>-<purpose>
  policy_full_name = format("%s-%s-iam-%s", var.environment, var.system, var.policy_name)

  policy_description = coalesce(var.description, "IAM policy for ${local.policy_full_name}")

  required_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags = merge(local.required_tags, var.additional_tags)
}

data "aws_iam_policy_document" "this" {
  statement {
    sid     = "AllowConfiguredActions"
    effect  = "Allow"
    actions = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_full_name
  description = local.policy_description
  path        = var.policy_path
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.tags
}
