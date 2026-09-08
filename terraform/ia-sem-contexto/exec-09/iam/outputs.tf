output "policy_arn" {
  description = "ARN da IAM Policy criada."
  value       = aws_iam_policy.this.arn
}

output "policy_name" {
  description = "Nome da IAM Policy criada."
  value       = aws_iam_policy.this.name
}

output "policy_path" {
  description = "Caminho da IAM Policy."
  value       = aws_iam_policy.this.path
}

output "policy_id" {
  description = "Policy ID único da IAM Policy (diferente do ARN)."
  value       = aws_iam_policy.this.policy_id
}

output "default_version_id" {
  description = "ID da versão padrão da IAM Policy."
  value       = aws_iam_policy.this.default_version_id
}

output "policy_document_json" {
  description = "Documento JSON efetivo da IAM Policy."
  value       = data.aws_iam_policy_document.this.json
}

output "attached_users" {
  description = "Usuários solicitados para anexo da policy."
  value       = sort(var.attach_to_users)
}

output "attached_roles" {
  description = "Roles solicitadas para anexo da policy."
  value       = sort(var.attach_to_roles)
}

output "attached_groups" {
  description = "Grupos solicitados para anexo da policy."
  value       = sort(var.attach_to_groups)
}

output "attachments_count" {
  description = "Quantidade total de anexos da policy (users + roles + groups)."
  value       = length(aws_iam_user_policy_attachment.this) + length(aws_iam_role_policy_attachment.this) + length(aws_iam_group_policy_attachment.this)
}
