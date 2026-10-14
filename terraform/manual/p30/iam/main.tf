locals {
  role_name            = "${var.environment}-${var.system}-iam-${var.role_name}"
  policy_name          = "${var.environment}-${var.system}-iam-policy-${var.role_name}"
  instance_profile_name = "${var.environment}-${var.system}-iam-instance-profile-${var.role_name}"

  role_tags = merge(
    var.additional_tags,
    var.required_tags,
    {
      Environment = var.environment
      Owner       = var.owner
      Name        = local.role_name
    }
  )

  policy_tags = merge(
    var.additional_tags,
    var.required_tags,
    {
      Environment = var.environment
      Owner       = var.owner
      Name        = local.policy_name
    }
  )

  instance_profile_tags = merge(
    var.additional_tags,
    var.required_tags,
    {
      Environment = var.environment
      Owner       = var.owner
      Name        = local.instance_profile_name
    }
  )

  has_permission_statements = length(var.s3_read_bucket_arns) > 0 || length(var.additional_allowed_actions_by_resource) > 0
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AllowTrustedService"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [var.trusted_principal_arn]
    }

    dynamic "condition" {
      for_each = var.trust_source_account_id == null ? [] : [var.trust_source_account_id]

      content {
        test     = "StringEquals"
        variable = "aws:SourceAccount"
        values   = [condition.value]
      }
    }

    dynamic "condition" {
      for_each = var.trust_source_arn == null ? [] : [var.trust_source_arn]

      content {
        test     = "ArnLike"
        variable = "aws:SourceArn"
        values   = [condition.value]
      }
    }
  }
}

data "aws_iam_policy_document" "permissions" {
  count = local.has_permission_statements ? 1 : 0

  dynamic "statement" {
    for_each = length(var.s3_read_bucket_arns) > 0 ? [true] : []

    content {
      sid       = "ListConfiguredS3Buckets"
      effect    = "Allow"
      actions   = ["s3:ListBucket"]
      resources = var.s3_read_bucket_arns
    }
  }

  dynamic "statement" {
    for_each = length(var.s3_read_bucket_arns) > 0 ? [true] : []

    content {
      sid       = "ReadObjectsInConfiguredS3Buckets"
      effect    = "Allow"
      actions   = ["s3:GetObject"]
      resources = [for arn in var.s3_read_bucket_arns : "${arn}/*"]
    }
  }

  dynamic "statement" {
    for_each = var.additional_allowed_actions_by_resource

    content {
      sid       = statement.value.sid
      effect    = "Allow"
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = local.role_name
  description          = var.role_description
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  max_session_duration = var.max_session_duration
  permissions_boundary = var.permissions_boundary_arn
  path                 = var.path
  tags                 = local.role_tags
}

resource "aws_iam_policy" "permissions" {
  count = local.has_permission_statements ? 1 : 0

  name        = local.policy_name
  description = "Least-privilege permissions for ${local.role_name}."
  path        = var.path
  policy      = data.aws_iam_policy_document.permissions[0].json
  tags        = local.policy_tags
}

resource "aws_iam_role_policy_attachment" "permissions" {
  count = local.has_permission_statements ? 1 : 0

  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.permissions[0].arn
}

resource "aws_iam_role_policy_attachment" "ssm" {
  count = var.enable_ssm_access ? 1 : 0

  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0

  name = local.instance_profile_name
  path = var.path
  role = aws_iam_role.this.name
  tags = local.instance_profile_tags
}
