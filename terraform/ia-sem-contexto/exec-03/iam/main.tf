terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "GeneratedPolicyStatement"
    effect    = var.effect
    actions   = var.actions
    resources = var.resources
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.path
  description = var.description
  policy      = data.aws_iam_policy_document.this.json

  tags = var.tags
}
