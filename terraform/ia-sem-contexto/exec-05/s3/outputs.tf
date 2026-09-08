output "bucket_name" {
  description = "Nome do bucket S3 criado."
  value       = aws_s3_bucket.this.bucket
}

output "bucket_arn" {
  description = "ARN do bucket S3."
  value       = aws_s3_bucket.this.arn
}

output "bucket_regional_domain_name" {
  description = "Domain name regional do bucket."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "bucket_hosted_zone_id" {
  description = "Hosted Zone ID para criar alias records no Route53."
  value       = aws_s3_bucket.this.hosted_zone_id
}

output "bucket_policy_id" {
  description = "ID da política associada ao bucket (nega tráfego sem TLS)."
  value       = aws_s3_bucket_policy.this.id
}
