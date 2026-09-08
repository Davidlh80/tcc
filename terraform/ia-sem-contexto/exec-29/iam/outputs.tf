output "iam_policy_arn" {
  description = "ARN da IAM Policy criada."
  value       = aws_iam_policy.this.arn
}

output "iam_policy_name" {
  description = "Nome da IAM Policy criada."
  value       = aws_iam_policy.this.name
}

output "iam_policy_id" {
  description = "ID da IAM Policy criada."
  value       = aws_iam_policy.this.id
}

output "iam_policy_path" {
  description = "Caminho (path) da IAM Policy criada."
  value       = aws_iam_policy.this.path
}

output "iam_policy_document" {
  description = "Documento JSON efetivo da policy."
  value       = aws_iam_policy.this.policy
}

output "iam_policy_tags" {
  description = "Tags aplicadas à IAM Policy."
  value       = aws_iam_policy.this.tags
}
