provider "aws" {
  region = var.aws_region
}

locals {
  default_tags = {
    ManagedBy = "terraform"
    Component = "iam-policy"
  }

  tags = merge(local.default_tags, var.tags)

  base_statement = {
    effect    = var.effect
    actions   = var.actions
    resources = var.resources
  }

  statements_merged = concat([local.base_statement], var.additional_statements)
}

data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = local.statements_merged
    content {
      effect    = upper(statement.value.effect)
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}

locals {
  policy_document_json = coalesce(var.policy_json, data.aws_iam_policy_document.this.json)
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.path
  description = var.policy_description
  policy      = local.policy_document_json
  tags        = local.tags
}
