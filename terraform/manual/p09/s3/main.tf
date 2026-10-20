resource "aws_s3_bucket" "template_bucket" {
  bucket = var.name

  tags = {
    name        = var.name
    environment = var.environment
    owner       = var.owner
  }
}

resource "aws_s3_bucket_public_access_block" "template_public_access_block" {
  bucket = aws_s3_bucket.template_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_kms_key" "template_kms_key" {
  description             = "Key used to encrypt bucket objects"
  enable_key_rotation     = true
  deletion_window_in_days = 10

  tags = {
    name        = var.name
    environment = var.environment
    owner       = var.owner
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "template_sse_config" {
  bucket = aws_s3_bucket.template_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.template_kms_key.id
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "template_bucket_versioning" {
  bucket = aws_s3_bucket.template_bucket.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}
