output "bucket_id" {
  description = "Nome (ID) do bucket S3 criado."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN do bucket S3 criado."
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "Domain name padrão do bucket S3."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Domain name regional do bucket S3."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}
