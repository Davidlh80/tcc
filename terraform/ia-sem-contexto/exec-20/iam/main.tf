provider "aws" {
  region = var.aws_region
}

data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = var.statements
    content {
      effect    = upper(statement.value.effect)
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = var.name
  description = var.description
  path        = var.path
  policy      = data.aws_iam_policy_document.this.json
  tags        = var.tags
}
