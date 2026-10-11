output "s3_bucket_name" {
  description = "Nome do bucket S3"
  value       = aws_s3_bucket.this.id
}

output "s3_bucket_arn" {
  description = "ARN do bucket S3"
  value       = aws_s3_bucket.this.arn
}
