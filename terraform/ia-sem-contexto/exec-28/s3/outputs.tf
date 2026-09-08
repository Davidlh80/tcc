output "bucket_id" {
  description = "ID do bucket (nome)."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN do bucket S3."
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "Domain name público do bucket."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Domain name regional do bucket."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "versioning_status" {
  description = "Status do versionamento (Enabled/Suspended)."
  value       = aws_s3_bucket_versioning.this.status
}

output "encryption_algorithm" {
  description = "Algoritmo de criptografia configurado (AES256 ou aws:kms)."
  value       = local.sse_algorithm
}

output "kms_key_arn_in_use" {
  description = "ARN da chave KMS usada, se aplicável."
  value       = local.kms_key_arn != "" ? local.kms_key_arn : null
}

output "region" {
  description = "Região AWS utilizada pelo provider."
  value       = var.aws_region
}
