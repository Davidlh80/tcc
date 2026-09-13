provider "aws" {
  region = var.aws_region
}

data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = var.statements
    content {
      sid       = statement.value.sid
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = var.name
  path        = var.path
  description = var.description
  policy      = data.aws_iam_policy_document.this.json

  tags = merge(
    {
      "ManagedBy" = "Terraform"
    },
    var.tags
  )
}
