terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.region
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "CustomManagedStatement"
    effect    = var.effect
    actions   = var.actions
    resources = var.resources
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.policy_path
  description = var.policy_description
  policy      = data.aws_iam_policy_document.this.json
  tags        = var.tags

  lifecycle {
    precondition {
      condition     = var.allow_wildcard_actions || !anytrue([for a in var.actions : a == "*"])
      error_message = "O uso da acao curinga \"*\" nao e permitido a menos que allow_wildcard_actions seja definido como true."
    }

    precondition {
      condition     = var.allow_wildcard_resources || !contains(var.resources, "*")
      error_message = "O uso do recurso curinga \"*\" nao e permitido a menos que allow_wildcard_resources seja definido como true."
    }
  }
}
