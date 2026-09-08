output "policy_arn" {
  description = "ARN da IAM Policy criada."
  value       = aws_iam_policy.this.arn
}

output "policy_name" {
  description = "Nome da IAM Policy criada."
  value       = aws_iam_policy.this.name
}

output "policy_id" {
  description = "ID da IAM Policy criada."
  value       = aws_iam_policy.this.id
}

output "policy_path" {
  description = "Caminho (path) da IAM Policy criada."
  value       = aws_iam_policy.this.path
}

output "policy_default_version_id" {
  description = "ID da versão padrão da IAM Policy."
  value       = aws_iam_policy.this.default_version_id
}

output "policy_document_json" {
  description = "Documento JSON efetivo da IAM Policy."
  value       = data.aws_iam_policy_document.this.json
}

output "policy_tags" {
  description = "Tags aplicadas na IAM Policy."
  value       = aws_iam_policy.this.tags_all
}
