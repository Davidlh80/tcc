provider "aws" {
  region = var.region
}

locals {
  # Nomenclatura: <ambiente>-<sistema>-<recurso>-<finalidade>
  name = lower("${var.environment}-${var.system}-iam-${var.policy_name}")

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
}

data "aws_iam_policy_document" "allow" {
  statement {
    sid     = "AllowConfiguredActions"
    effect  = "Allow"
    actions = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = local.name
  description = var.description
  path        = var.path
  policy      = data.aws_iam_policy_document.allow.json
  tags        = local.tags
}
