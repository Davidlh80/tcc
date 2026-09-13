terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.region
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "GeneratedStatement"
    effect    = var.effect
    actions   = var.actions
    resources = var.resources

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
  path        = var.path
  description = var.policy_description
  policy      = data.aws_iam_policy_document.this.json

  tags = var.tags

  lifecycle {
    precondition {
      condition     = var.allow_wildcard_actions || !contains(var.actions, "*")
      error_message = "O uso de action '*' (wildcard total) nao e permitido por padrao. Especifique acoes explicitas ou defina allow_wildcard_actions = true para reconhecer o risco."
    }

    precondition {
      condition     = var.allow_wildcard_resources || !contains(var.resources, "*")
      error_message = "O uso de resource '*' (wildcard total) nao e permitido por padrao. Especifique ARNs explicitos ou defina allow_wildcard_resources = true para reconhecer o risco."
    }
  }
}
