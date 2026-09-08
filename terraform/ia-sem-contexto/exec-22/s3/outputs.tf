output "bucket_id" {
  description = "ID do bucket (igual ao nome)."
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
  description = "DNS global do bucket."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "DNS regional do bucket."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "bucket_hosted_zone_id" {
  description = "Hosted Zone ID do endpoint S3 regional do bucket."
  value       = aws_s3_bucket.this.hosted_zone_id
}

output "region" {
  description = "Regiao AWS utilizada."
  value       = var.aws_region
}
