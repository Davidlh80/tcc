provider "aws" {
  region = var.region
}

locals {
  common_tags = {
    ManagedBy = "Terraform"
    Module    = "iam-policy-blueprint"
  }

  merged_tags = merge(local.common_tags, var.tags)
}

data "aws_iam_policy_document" "this" {
  statement {
    effect    = var.policy_effect
    actions   = var.policy_actions
    resources = var.policy_resources
  }
}

resource "aws_iam_policy" "this" {
  count       = var.enabled ? 1 : 0
  name        = var.policy_name
  description = var.policy_description
  path        = var.policy_path
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.merged_tags

  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}
