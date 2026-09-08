provider "aws" {
  region = var.aws_region
}

data "aws_iam_policy_document" "generated" {
  count = var.policy_json == null ? 1 : 0

  statement {
    effect = var.effect

    actions = var.allowed_actions

    resources = var.resources
  }
}

locals {
  rendered_policy = var.policy_json != null ? var.policy_json : data.aws_iam_policy_document.generated[0].json
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.policy_path
  description = var.policy_description
  policy      = local.rendered_policy
}
