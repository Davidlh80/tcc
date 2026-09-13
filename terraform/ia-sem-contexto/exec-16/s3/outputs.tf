output "bucket_id" {
  description = "Identificador (nome) do bucket S3 criado."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN do bucket S3 criado."
  value       = aws_s3_bucket.this.arn
}

output "bucket_regional_domain_name" {
  description = "Nome de dominio regional do bucket S3."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "bucket_versioning_status" {
  description = "Status atual do versionamento do bucket."
  value       = aws_s3_bucket_versioning.this.versioning_configuration[0].status
}
