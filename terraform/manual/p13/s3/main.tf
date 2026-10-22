locals {
  bucket_tags = merge(var.additional_tags, {
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = "tcc-iac-p31"
    Name        = var.bucket_name
  })
}

resource "aws_s3_bucket" "data" {
  bucket = var.bucket_name
  tags   = local.bucket_tags
}

resource "aws_s3_bucket_public_access_block" "data" {
  bucket = aws_s3_bucket.data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data" {
  bucket = aws_s3_bucket.data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "data" {
  bucket = aws_s3_bucket.data.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "data" {
  count  = var.versioning_enabled ? 1 : 0
  bucket = aws_s3_bucket.data.id

  versioning_configuration {
    status = "Enabled"
  }
}
