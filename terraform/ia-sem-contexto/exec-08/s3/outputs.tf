output "bucket_id" {
  description = "ID do bucket S3."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN do bucket S3."
  value       = aws_s3_bucket.this.arn
}

output "bucket_name" {
  description = "Nome do bucket S3."
  value       = aws_s3_bucket.this.bucket
}

output "bucket_domain_name" {
  description = "Domain name do bucket S3."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Regional domain name do bucket S3."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "versioning_status" {
  description = "Status do versionamento (Enabled ou Suspended)."
  value       = aws_s3_bucket_versioning.this.versioning_configuration[0].status
}

output "encryption_type" {
  description = "Tipo de criptografia server-side aplicada por padrão."
  value       = var.kms_key_arn != "" ? "aws:kms" : "AES256"
}

output "bucket_policy_document" {
  description = "Política do bucket (JSON)."
  value       = aws_s3_bucket_policy.https_only.policy
}

output "region" {
  description = "Região AWS usada pelo provider."
  value       = var.aws_region
}
