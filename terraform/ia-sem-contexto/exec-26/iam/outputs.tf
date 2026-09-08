output "policy_arn" {
  description = "ARN da IAM Policy criada."
  value       = aws_iam_policy.this.arn
}

output "policy_name" {
  description = "Nome da IAM Policy criada."
  value       = aws_iam_policy.this.name
}

output "policy_id" {
  description = "ID interno da IAM Policy."
  value       = aws_iam_policy.this.id
}

output "default_version_id" {
  description = "ID da versao padrao da IAM Policy."
  value       = aws_iam_policy.this.default_version_id
}

output "rendered_policy_json" {
  description = "Documento JSON final da policy aplicada (raw JSON)."
  value       = local.rendered_policy
  sensitive   = false
}
