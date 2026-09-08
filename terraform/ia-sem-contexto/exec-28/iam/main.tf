locals {
  default_tags = {
    ManagedBy = "Terraform"
  }

  final_policy_json = var.policy_json != null ? var.policy_json : data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    sid     = "DefaultAllow"
    effect  = "Allow"
    actions = var.actions
    resources = var.resources
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.policy_path
  description = var.policy_description
  policy      = local.final_policy_json
  tags        = merge(local.default_tags, var.tags)
}
