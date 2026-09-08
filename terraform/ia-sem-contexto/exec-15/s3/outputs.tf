output "bucket_id" {
  description = "ID do bucket (nome)."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN do bucket."
  value       = aws_s3_bucket.this.arn
}

output "bucket_name" {
  description = "Nome do bucket."
  value       = aws_s3_bucket.this.bucket
}

output "bucket_domain_name" {
  description = "Domain name do bucket (global)."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Domain name regional do bucket."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "bucket_hosted_zone_id" {
  description = "Hosted zone ID do S3 para records alias."
  value       = aws_s3_bucket.this.hosted_zone_id
}

output "bucket_versioning_status" {
  description = "Status do versionamento: Enabled ou Suspended."
  value       = aws_s3_bucket_versioning.this.status
}

output "encryption_algorithm" {
  description = "Algoritmo de criptografia em repouso do bucket."
  value       = var.sse_algorithm
}

output "kms_key_arn" {
  description = "ARN da chave KMS utilizada (se configurada)."
  value       = var.kms_key_arn
}

output "bucket_policy_id" {
  description = "ID da bucket policy criada (ou null se desabilitada)."
  value       = try(aws_s3_bucket_policy.secure_transport[0].id, null)
}

output "region" {
  description = "Regiao do provider AWS utilizada."
  value       = var.region
}
