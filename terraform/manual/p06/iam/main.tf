data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = [var.trusted_service]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "app" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = var.tags
}

data "aws_iam_policy_document" "read_objects" {
  statement {
    sid    = "ListBucketPrefix"
    effect = "Allow"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name}",
    ]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["${var.object_prefix}*"]
    }
  }

  statement {
    sid    = "ReadObjects"
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name}/${var.object_prefix}*",
    ]
  }
}

resource "aws_iam_role_policy" "read_objects" {
  name   = "${var.role_name}-read-objects"
  role   = aws_iam_role.app.id
  policy = data.aws_iam_policy_document.read_objects.json
}
