data "aws_iam_policy_document" "trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "custom_policy" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::meu-bucket-exemplo-abc/*"]
  }
}

resource "aws_iam_policy" "this" {
  name        = "${var.policy_name}-${var.environment}"
  description = "politica com menor privilegio"
  policy      = data.aws_iam_policy_document.custom_policy.json
}

resource "aws_iam_role" "this" {
  name               = "${var.role_name}-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
