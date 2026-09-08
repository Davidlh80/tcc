provider "aws" {
  region = var.aws_region
}

# Documento da policy construído de forma declarativa
data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = var.statements
    content {
      sid     = try(statement.value.sid, null)
      effect  = upper(try(statement.value.effect, "Allow"))

      actions      = try(statement.value.actions, null)
      not_actions  = try(statement.value.not_actions, null)
      resources    = try(statement.value.resources, null)
      not_resources = try(statement.value.not_resources, null)

      dynamic "condition" {
        for_each = try(statement.value.conditions, [])
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

# Policy gerenciada (Customer Managed Policy)
resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = var.policy_description
  path        = var.policy_path
  policy      = data.aws_iam_policy_document.this.json
  tags        = var.tags
}
