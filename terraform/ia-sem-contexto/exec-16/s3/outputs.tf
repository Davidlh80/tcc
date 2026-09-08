output "bucket_id" {
  description = "ID do bucket S3 (igual ao nome)."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN do bucket S3."
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "Domain name do bucket."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Domain name regional do bucket."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "versioning_status" {
  description = "Status do versionamento do bucket."
  value       = aws_s3_bucket_versioning.this.versioning_configuration[0].status
}

output "encryption_algorithm" {
  description = "Algoritmo de criptografia padrao do bucket."
  value       = var.sse_kms_key_arn != null ? "aws:kms" : "AES256"
}

output "kms_key_arn" {
  description = "ARN da chave KMS utilizada (se aplicavel)."
  value       = var.sse_kms_key_arn
}

output "logging_enabled" {
  description = "Se o server access logging esta habilitado."
  value       = var.logging_enabled
}

output "aws_region" {
  description = "Regiao AWS utilizada pelo provider."
  value       = var.aws_region
}
