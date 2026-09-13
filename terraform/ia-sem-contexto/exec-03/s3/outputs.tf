output "bucket_id" {
  description = "Nome (ID) do bucket S3 criado."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN do bucket S3 criado."
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "Nome de domínio do bucket S3."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Nome de domínio regional do bucket S3."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "versioning_status" {
  description = "Status do versionamento configurado no bucket."
  value       = aws_s3_bucket_versioning.this.versioning_configuration[0].status
}
