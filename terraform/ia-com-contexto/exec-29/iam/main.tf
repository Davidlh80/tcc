provider "aws" {
  region = var.region
}

locals {
  required_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags = merge(local.required_tags, var.additional_tags)

  policy_name_full = "${var.environment}-${var.system}-iam-${var.policy_name}"
}

data "aws_iam_policy_document" "this" {
  statement {
    sid     = "AllowExplicitActionsOnResources"
    effect  = "Allow"
    actions = var.allowed_actions

    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_name_full
  description = var.description
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.tags
}
