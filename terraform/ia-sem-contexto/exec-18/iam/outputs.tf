output "iam_policy_arn" {
  description = "ARN da IAM Policy criada."
  value       = length(aws_iam_policy.this) > 0 ? aws_iam_policy.this[0].arn : null
}

output "iam_policy_name" {
  description = "Nome da IAM Policy criada."
  value       = length(aws_iam_policy.this) > 0 ? aws_iam_policy.this[0].name : null
}

output "iam_policy_id" {
  description = "ID interno (policy_id) atribuído pela AWS."
  value       = length(aws_iam_policy.this) > 0 ? aws_iam_policy.this[0].policy_id : null
}

output "iam_policy_path" {
  description = "Caminho (path) da IAM Policy."
  value       = length(aws_iam_policy.this) > 0 ? aws_iam_policy.this[0].path : null
}

output "iam_policy_document_json" {
  description = "Documento JSON da policy efetivamente utilizado."
  value       = local.policy_document
}
