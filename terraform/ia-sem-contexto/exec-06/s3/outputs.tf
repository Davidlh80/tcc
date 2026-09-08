output "bucket_id" {
  description = "ID do bucket (nome)."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN do bucket."
  value       = aws_s3_bucket.this.arn
}

output "bucket_regional_domain_name" {
  description = "Nome de domínio regional do bucket."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "bucket_hosted_zone_id" {
  description = "Hosted Zone ID para registros alias no Route53."
  value       = aws_s3_bucket.this.hosted_zone_id
}

output "encryption_algorithm" {
  description = "Algoritmo de criptografia padrão do bucket."
  value       = local.use_kms ? "aws:kms" : "AES256"
}

output "kms_key_arn_in_use" {
  description = "ARN da KMS Key utilizada (se aplicável)."
  value       = local.use_kms ? var.kms_key_arn : ""
}

output "versioning_enabled" {
  description = "Indica se o versionamento está habilitado."
  value       = var.enable_versioning
}
