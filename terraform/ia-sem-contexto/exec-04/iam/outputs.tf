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

output "policy_path" {
  description = "Path da IAM Policy."
  value       = aws_iam_policy.this.path
}

output "policy_description" {
  description = "Descrição da IAM Policy."
  value       = aws_iam_policy.this.description
}

output "policy_document_json" {
  description = "Documento de policy em JSON utilizado para criar a IAM Policy."
  value       = aws_iam_policy.this.policy
}
