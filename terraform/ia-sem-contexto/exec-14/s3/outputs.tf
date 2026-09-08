output "bucket_name" {
  description = "Nome do bucket S3."
  value       = aws_s3_bucket.this.bucket
}

output "bucket_arn" {
  description = "ARN do bucket S3."
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "Endpoint do bucket (legacy global)."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Endpoint regional do bucket."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "hosted_zone_id" {
  description = "Hosted Zone ID do endpoint S3 para integracao com Route53."
  value       = aws_s3_bucket.this.hosted_zone_id
}

output "versioning_status" {
  description = "Status do versionamento do bucket."
  value       = aws_s3_bucket_versioning.this.versioning_configuration[0].status
}

output "encryption_algorithm" {
  description = "Algoritmo de criptografia padrao aplicado ao bucket (AES256 ou aws:kms)."
  value       = local.encryption_algorithm
}
