output "bucket_name" {
  description = "bucket_name do recurso criado."
  value       = aws_s3_bucket.this.bucket
}

output "bucket_arn" {
  description = "bucket_arn do recurso criado."
  value       = aws_s3_bucket.this.arn
}

output "bucket_id" {
  description = "bucket_id do recurso criado."
  value       = aws_s3_bucket.this.id
}
