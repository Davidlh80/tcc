provider "aws" {
  region = var.aws_region

  # Default tags applied to all resources created by this provider
  default_tags {
    tags = var.tags
  }
}

data "aws_iam_policy_document" "this" {
  statement {
    effect    = var.policy_effect
    actions   = var.policy_actions
    resources = var.policy_resources

    dynamic "condition" {
      for_each = var.policy_conditions
      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.policy_path
  description = var.policy_description
  policy      = data.aws_iam_policy_document.this.json
  tags        = var.tags
}
