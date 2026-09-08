output "policy_arn" {
  description = "ARN da IAM Policy."
  value       = aws_iam_policy.this.arn
}

output "policy_name" {
  description = "Nome da IAM Policy."
  value       = aws_iam_policy.this.name
}

output "policy_path" {
  description = "Caminho (path) da IAM Policy."
  value       = aws_iam_policy.this.path
}

output "policy_id" {
  description = "ID da IAM Policy."
  value       = aws_iam_policy.this.id
}

output "default_version_id" {
  description = "ID da versao padrao da IAM Policy."
  value       = aws_iam_policy.this.default_version_id
}

output "effective_policy_document" {
  description = "Documento JSON efetivo aplicado na IAM Policy."
  value       = local.effective_policy_json
}

output "attached_to_roles" {
  description = "Lista de roles as quais a policy foi anexada."
  value       = length(aws_iam_role_policy_attachment.this) > 0 ? sort(keys(aws_iam_role_policy_attachment.this)) : []
}

output "attached_to_users" {
  description = "Lista de users aos quais a policy foi anexada."
  value       = length(aws_iam_user_policy_attachment.this) > 0 ? sort(keys(aws_iam_user_policy_attachment.this)) : []
}

output "attached_to_groups" {
  description = "Lista de groups aos quais a policy foi anexada."
  value       = length(aws_iam_group_policy_attachment.this) > 0 ? sort(keys(aws_iam_group_policy_attachment.this)) : []
}
