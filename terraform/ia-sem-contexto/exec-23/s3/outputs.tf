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
  description = "Domain name público (compatível com assinatura path-style)."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Domain name regional do bucket."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "region" {
  description = "Região AWS utilizada."
  value       = var.region
}

output "versioning_status" {
  description = "Status do versionamento do bucket."
  value       = aws_s3_bucket_versioning.this.versioning_configuration[0].status
}

output "sse_algorithm" {
  description = "Algoritmo SSE configurado."
  value       = var.sse_algorithm
}

output "bucket_policy_id" {
  description = "ID da política do bucket (se criada)."
  value       = try(aws_s3_bucket_policy.this[0].id, null)
}
