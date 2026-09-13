terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.region
}

data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = var.policy_statements

    content {
      sid       = lookup(statement.value, "sid", null)
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
