provider "aws" {
  region = var.aws_region
}

data "aws_iam_policy_document" "this" {
  statement {
    sid     = var.statement_sid
    effect  = var.effect
    actions = var.allowed_actions
    resources = var.allowed_resources
  }
}

locals {
  default_tags = {
    ManagedBy = "Terraform"
  }

  effective_tags = merge(local.default_tags, var.tags)

  effective_policy_json = (
    var.policy_json != null && length(trim(var.policy_json)) > 0
  ) ? var.policy_json : data.aws_iam_policy_document.this.json
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = var.policy_description
  path        = var.path
  policy      = local.effective_policy_json
  tags        = local.effective_tags
}
