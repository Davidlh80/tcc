locals {
  resource_type = "s3"

  bucket_name = lower(format("%s-%s-%s-%s", var.environment, var.system, local.resource_type, var.purpose))

  mandatory_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags = merge(var.additional_tags, local.mandatory_tags)
}

resource "aws_s3_bucket" "this" {
  bucket        = local.bucket_name
  force_destroy = var.force_destroy
  tags          = local.tags

  lifecycle {
    precondition {
      condition     = length(local.bucket_name) >= 3 && length(local.bucket_name) <= 63
      error_message = "O nome do bucket deve ter entre 3 e 63 caracteres."
    }
    precondition {
      condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", local.bucket_name))
      error_message = "O nome do bucket deve conter apenas letras minúsculas, números e hífens, não iniciando/terminando com hífen."
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning_status
  }
}

data "aws_iam_policy_document" "deny_insecure_transport" {
  statement {
    sid     = "DenyInsecureTransport"
    effect  = "Deny"
    actions = ["s3:*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.deny_insecure_transport.json

  depends_on = [
    aws_s3_bucket_public_access_block.this,
    aws_s3_bucket_ownership_controls.this
  ]
}

output "bucket_name" {
  description = "Nome do bucket S3 criado seguindo o padrão <environment>-<system>-s3-<purpose>."
  value       = aws_s3_bucket.this.bucket
}

output "bucket_arn" {
  description = "ARN do bucket S3."
  value       = aws_s3_bucket.this.arn
}

output "bucket_id" {
  description = "ID do bucket S3 (normalmente igual ao nome)."
  value       = aws_s3_bucket.this.id
}
