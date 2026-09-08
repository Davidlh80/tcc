provider "aws" {
  region = var.aws_region
}

data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = var.statements
    iterator = s
    content {
      effect    = upper(s.value.effect)
      actions   = s.value.actions
      resources = s.value.resources

      dynamic "condition" {
        for_each = coalesce(s.value.conditions, [])
        iterator = c
        content {
          test     = c.value.test
          variable = c.value.variable
          values   = c.value.values
        }
      }
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.path
  description = var.description
  policy      = data.aws_iam_policy_document.this.json
  tags        = var.tags
}
