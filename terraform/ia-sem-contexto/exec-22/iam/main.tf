terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "GeneratedStatement"
    effect    = var.effect
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.path
  description = var.policy_description
  policy      = data.aws_iam_policy_document.this.json

  tags = var.tags
}
