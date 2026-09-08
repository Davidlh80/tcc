output "policy_arn" {
  description = "ARN da IAM Policy criada."
  value       = aws_iam_policy.this.arn
}

output "policy_name" {
  description = "Nome efetivo da IAM Policy."
  value       = aws_iam_policy.this.name
}

output "policy_id" {
  description = "ID interno da IAM Policy."
  value       = aws_iam_policy.this.id
}

output "policy_path" {
  description = "Path atribuído à IAM Policy."
  value       = aws_iam_policy.this.path
}

output "policy_default_version_id" {
  description = "ID da versão padrão da policy."
  value       = aws_iam_policy.this.default_version_id
}

output "policy_document_json" {
  description = "Documento de policy em JSON."
  value       = aws_iam_policy.this.policy
}

output "policy_tags" {
  description = "Tags aplicadas à IAM Policy."
  value       = aws_iam_policy.this.tags
}
