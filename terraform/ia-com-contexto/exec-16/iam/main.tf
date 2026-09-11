provider "aws" {
  region = var.region
}

locals {
  # Nome padronizado: <ambiente>-<sistema>-<recurso>-<finalidade>
  iam_policy_name = "${var.environment}-${var.system}-iam-${var.policy_name}"

  required_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags = merge(var.additional_tags, local.required_tags)
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
  name        = local.iam_policy_name
  description = var.description
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.tags
}
