provider "aws" {
  region = var.aws_region
}

locals {
  # Tags padrao mescladas com as fornecidas
  default_tags = {
    ManagedBy = "Terraform"
  }

  merged_tags = merge(local.default_tags, var.tags)
}

data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = var.statements
    content {
      sid     = try(statement.value.sid, null)
      effect  = upper(try(statement.value.effect, "ALLOW"))
      actions = tolist(statement.value.actions)

      resources = tolist(statement.value.resources)

      dynamic "condition" {
        for_each = try(statement.value.conditions, [])
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = tolist(condition.value.values)
        }
      }
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name != null ? var.policy_name : null
  name_prefix = var.policy_name == null ? var.policy_name_prefix : null
  description = var.policy_description
  path        = var.policy_path
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.merged_tags
}
