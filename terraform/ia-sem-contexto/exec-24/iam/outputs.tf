output "iam_policy_arn" {
  description = "ARN da IAM Policy criada."
  value       = aws_iam_policy.this.arn
}

output "iam_policy_name" {
  description = "Nome da IAM Policy criada."
  value       = aws_iam_policy.this.name
}

output "iam_policy_id" {
  description = "ID exclusivo (policy_id) atribuído pela AWS para a policy."
  value       = aws_iam_policy.this.policy_id
}

output "iam_policy_default_version_id" {
  description = "ID da versão padrão da policy."
  value       = aws_iam_policy.this.default_version_id
}

output "iam_policy_document_json" {
  description = "Documento JSON efetivo da policy."
  value       = data.aws_iam_policy_document.this.json
}
