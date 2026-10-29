locals {
  name_prefix = "${var.project_name}-${var.environment}"
  bucket_arn  = "arn:aws:s3:::${var.bucket_name}"
}

# Quem pode assumir a role: apenas instâncias EC2
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "app" {
  name               = "${local.name_prefix}-app-role"
  description        = "Role para EC2 acessar somente um bucket especifico"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Menor privilégio: só listar/ler/gravar no bucket informado
data "aws_iam_policy_document" "app_s3" {
  statement {
    sid       = "ListBucket"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [local.bucket_arn]
  }

  statement {
    sid       = "ReadWriteObjects"
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["${local.bucket_arn}/*"]
  }
}

resource "aws_iam_policy" "app_s3" {
  name        = "${local.name_prefix}-app-s3-policy"
  description = "Leitura e escrita no bucket ${var.bucket_name}"
  policy      = data.aws_iam_policy_document.app_s3.json
}

resource "aws_iam_role_policy_attachment" "app_s3" {
  role       = aws_iam_role.app.name
  policy_arn = aws_iam_policy.app_s3.arn
}

# Instance profile (para anexar a role a uma EC2)
resource "aws_iam_instance_profile" "app" {
  name = "${local.name_prefix}-app-profile"
  role = aws_iam_role.app.name
}
