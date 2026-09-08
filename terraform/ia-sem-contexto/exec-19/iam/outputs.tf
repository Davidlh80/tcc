output "policy_arn" {
  description = "ARN da IAM Policy criada."
  value       = try(aws_iam_policy.this[0].arn, null)
}

output "policy_name" {
  description = "Nome da IAM Policy criada."
  value       = try(aws_iam_policy.this[0].name, null)
}

output "policy_id" {
  description = "ID interno da IAM Policy."
  value       = try(aws_iam_policy.this[0].id, null)
}

output "policy_document_json" {
  description = "Documento JSON efetivo da policy."
  value       = data.aws_iam_policy_document.this.json
}
