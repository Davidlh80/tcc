output "bucket_name" {
  description = "Nome do bucket S3."
  value       = aws_s3_bucket.this.bucket
}

output "bucket_arn" {
  description = "ARN do bucket S3."
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "Domain name do bucket (compatível com região)."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Domain name regional do bucket."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "versioning_status" {
  description = "Status do versionamento (Enabled ou Suspended)."
  value       = aws_s3_bucket_versioning.this.versioning_configuration[0].status
}

output "public_access_block_id" {
  description = "ID do recurso de bloqueio de acesso público."
  value       = aws_s3_bucket_public_access_block.this.id
}
