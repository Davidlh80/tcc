provider "aws" {
  region = var.region
}

locals {
  resource_type = "iam"

  # Nome padronizado: <ambiente>-<sistema>-<recurso>-<finalidade>
  policy_full_name = "${var.environment}-${var.system}-${local.resource_type}-${var.policy_name}"

  default_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags = merge(local.default_tags, var.additional_tags)

  description = coalesce(var.description, "Least-privilege IAM policy for ${local.policy_full_name}")
}

data "aws_iam_policy_document" "this" {
  statement {
    sid     = "AllowExplicitActionsAndResources"
    effect  = "Allow"
    actions = tolist(var.allowed_actions)
    resources = tolist(var.allowed_resources)
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_full_name
  description = local.description
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.tags
}
