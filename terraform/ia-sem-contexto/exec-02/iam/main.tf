provider "aws" {
  region = var.aws_region
}

locals {
  default_tags = {
    ManagedBy = "Terraform"
  }

  merged_tags = merge(local.default_tags, var.tags)
}

data "aws_iam_policy_document" "this" {
  statement {
    sid    = var.statement_sid
    effect = var.policy_effect

    actions   = var.actions
    resources = var.resource_arns

    dynamic "condition" {
      for_each = var.conditions
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
  description = var.description
  path        = var.policy_path
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.merged_tags
}
