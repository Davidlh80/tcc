provider "aws" {
  region = var.aws_region
}

locals {
  statements_raw = [
    {
      Sid         = try(s.sid, null)
      Effect      = upper(s.effect) == "DENY" ? "Deny" : "Allow"
      Action      = try(s.actions, null)
      NotAction   = try(s.not_actions, null)
      Resource    = try(s.resources, null)
      NotResource = try(s.not_resources, null)
      Condition   = try(s.conditions, null)
    }
    for s in var.policy_statements
  ]

  statements = [
    { for k, v in s : k => v if v != null }
    for s in local.statements_raw
  ]

  policy_document = jsonencode({
    Version   = "2012-10-17"
    Statement = local.statements
  })
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = var.policy_description
  path        = var.policy_path
  policy      = local.policy_document
  tags        = var.tags

  lifecycle {
    precondition {
      condition = alltrue([
        for s in var.policy_statements :
        (length(try(s.actions, [])) > 0 || length(try(s.not_actions, [])) > 0) &&
        (length(try(s.resources, [])) > 0 || length(try(s.not_resources, [])) > 0)
      ])
      error_message = "Each statement must include at least one of actions or not_actions and one of resources or not_resources."
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each   = toset(var.attach_to_roles)
  role       = each.value
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_user_policy_attachment" "this" {
  for_each   = toset(var.attach_to_users)
  user       = each.value
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_group_policy_attachment" "this" {
  for_each   = toset(var.attach_to_groups)
  group      = each.value
  policy_arn = aws_iam_policy.this.arn
}
