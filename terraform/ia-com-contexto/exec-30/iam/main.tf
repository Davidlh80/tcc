provider "aws" {
  region = var.region
}

locals {
  resource_name = "${var.environment}-${var.system}-iam-${var.policy_name}"

  fixed_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  sanitized_additional_tags = {
    for k, v in var.additional_tags :
    k => v
    if !(k == "Project" || k == "Environment" || k == "ManagedBy" || k == "Owner" || k == "CostCenter")
  }

  tags = merge(local.fixed_tags, local.sanitized_additional_tags)
}

data "aws_iam_policy_document" "allow_only_configured" {
  statement {
    sid       = "AllowConfiguredActions"
    effect    = "Allow"
    actions   = tolist(var.allowed_actions)
    resources = tolist(var.allowed_resources)
  }
}

resource "aws_iam_policy" "this" {
  name        = local.resource_name
  path        = var.path
  description = var.policy_description
  policy      = data.aws_iam_policy_document.allow_only_configured.json
  tags        = local.tags
}
