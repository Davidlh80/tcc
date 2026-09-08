locals {
  default_policy_document = {
    Version = "2012-10-17"
    Statement = [
      {
        Sid     = "DenyInsecureTransport"
        Effect  = "Deny"
        Action  = "*"
        Resource = "*"
        Condition = {
          Bool = {
            "aws:SecureTransport" = false
          }
        }
      },
      {
        Sid     = "ReadOnlyCommonServices"
        Effect  = "Allow"
        Action  = [
          "ec2:Describe*",
          "rds:Describe*",
          "s3:Get*",
          "s3:List*",
          "cloudwatch:Get*",
          "cloudwatch:List*",
          "logs:Describe*",
          "logs:Get*",
          "logs:List*",
          "autoscaling:Describe*",
          "iam:Get*",
          "iam:List*",
          "sns:Get*",
          "sns:List*",
          "sqs:Get*",
          "sqs:List*",
          "tag:Get*",
          "tag:List*"
        ]
        Resource = "*"
      }
    ]
  }

  effective_policy_json = (
    var.policy_json != null && trim(var.policy_json) != ""
  ) ? var.policy_json : jsonencode(local.default_policy_document)

  common_tags = merge(
    { ManagedBy = "Terraform" },
    var.tags
  )
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = var.policy_description
  path        = var.policy_path
  policy      = local.effective_policy_json
  tags        = local.common_tags
}

resource "aws_iam_policy_attachment" "this" {
  count      = var.enable_attachments ? 1 : 0
  name       = "${var.policy_name}-attachment"
  policy_arn = aws_iam_policy.this.arn
  users      = var.attach_users
  roles      = var.attach_roles
  groups     = var.attach_groups
}
