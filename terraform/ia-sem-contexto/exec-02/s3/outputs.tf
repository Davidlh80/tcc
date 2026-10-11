output "bucket_id" {
  description = "Nome (ID) do bucket S3 criado."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN do bucket S3 criado."
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "Nome de dominio padrao do bucket S3."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Nome de dominio regional do bucket S3."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "versioning_enabled" {
  description = "Indica se o versionamento esta habilitado no bucket."
  value       = var.enable_versioning
}

output "sse_algorithm" {
  description = "Algoritmo de criptografia padrao configurado no bucket."
  value       = var.sse_algorithm
}

output "tags" {
  description = "Tags efetivamente aplicadas ao bucket."
  value       = local.tags
}
