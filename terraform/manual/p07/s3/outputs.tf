output "bucket_name" {
  description = "Nome do bucket."
  value       = aws_s3_bucket.main.bucket
}

output "bucket_arn" {
  description = "ARN do bucket."
  value       = aws_s3_bucket.main.arn
}

output "bucket_id" {
  description = "ID do bucket."
  value       = aws_s3_bucket.main.id
}
