output "bucket_name" {
  description = "nomme do bucket s3."
  value       = aws_s3_bucket.this.bucket
}

output "bucket_arn" {
  description = "ARN do bucket s3."
  value       = aws_s3_bucket.this.arn
}

output "bucket_id" {
  description = "ID do bucket s3."
  value       = aws_s3_bucket.this.id
}
