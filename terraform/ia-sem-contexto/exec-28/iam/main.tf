terraform {
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.aws_region
}

data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = var.policy_statements
    content {
      sid       = try(statement.value.sid, null)
      effect    = try(statement.value.effect, "Allow")
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = var.policy_description
  path        = var.path
  policy      = data.aws_iam_policy_document.this.json
  tags        = var.tags
}
