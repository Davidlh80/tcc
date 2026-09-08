provider "aws" {
  region = var.region
}

resource "random_id" "suffix" {
  byte_length = 3
}

locals {
  # Compute final policy name: use explicit name when provided, otherwise compose with prefix + random suffix
  policy_name = (
    var.policy_name != null && trim(var.policy_name) != ""
  ) ? var.policy_name : "${var.name_prefix}-${random_id.suffix.hex}"

  # Transform statements into IAM JSON policy structure
  statements = [
    for s in var.statements : merge(
      { Effect = s.effect },
      s.sid != null && trim(s.sid) != "" ? { Sid = s.sid } : {},
      try(length(s.actions), 0) > 0 ? { Action = s.actions } : {},
      try(length(s.not_actions), 0) > 0 ? { NotAction = s.not_actions } : {},
      try(length(s.resources), 0) > 0 ? { Resource = s.resources } : {},
      try(length(s.not_resources), 0) > 0 ? { NotResource = s.not_resources } : {},
      try(length(keys(s.conditions)), 0) > 0 ? {
        Condition = {
          for test, vars in s.conditions :
          test => { for varname, vals in vars : varname => vals }
        }
      } : {}
    )
  ]

  policy_document_json = jsonencode({
    Version  = "2012-10-17"
    Statement = local.statements
  })
}

resource "aws_iam_policy" "this" {
  name        = local.policy_name
  path        = var.path
  description = var.description
  policy      = local.policy_document_json
  tags        = var.tags
}
