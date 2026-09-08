output "policy_arn" {
  description = "ARN da IAM Policy."
  value       = aws_iam_policy.this.arn
}

output "policy_id" {
  description = "ID unico da IAM Policy."
  value       = aws_iam_policy.this.id
}

output "policy_name" {
  description = "Nome da IAM Policy."
  value       = aws_iam_policy.this.name
}

output "policy_path" {
  description = "Path da IAM Policy."
  value       = aws_iam_policy.this.path
}

output "policy_default_version_id" {
  description = "Versao padrao da IAM Policy."
  value       = aws_iam_policy.this.default_version_id
}

output "policy_document_json" {
  description = "Documento JSON efetivo aplicado na policy."
  value       = aws_iam_policy.this.policy
}

output "attachment_name" {
  description = "Nome do anexo da policy, quando criado."
  value       = var.enable_attachments ? aws_iam_policy_attachment.this[0].name : null
}

output "attachment_entities" {
  description = "Entidades (usuarios, roles, grupos) para as quais a policy foi anexada (se habilitado)."
  value = var.enable_attachments ? {
    users  = var.attach_users
    roles  = var.attach_roles
    groups = var.attach_groups
  } : {
    users  = []
    roles  = []
    groups = []
  }
}
