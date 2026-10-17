output "role_name" {
  description = "Nome da Role IAM."
  value       = aws_iam_role.this.name
}

output "role_arn" {
  description = "ARN da Role IAM."
  value       = aws_iam_role.this.arn
}

output "role_unique_id" {
  description = "ID exclusivo da Role IAM."
  value       = aws_iam_role.this.unique_id
}

output "policy_name" {
  description = "Nome da política de permissões, ou nulo quando nenhuma política customizada foi criada."
  value       = try(aws_iam_policy.permissions[0].name, null)
}

output "policy_arn" {
  description = "ARN da política de permissões, ou nulo quando nenhuma política customizada foi criada."
  value       = try(aws_iam_policy.permissions[0].arn, null)
}

output "policy_id" {
  description = "ID da política de permissões, ou nulo quando nenhuma política customizada foi criada."
  value       = try(aws_iam_policy.permissions[0].policy_id, null)
}

output "instance_profile_name" {
  description = "Nome do instance profile, ou nulo quando não foi criado."
  value       = try(aws_iam_instance_profile.this[0].name, null)
}

output "instance_profile_arn" {
  description = "ARN do instance profile, ou nulo quando não foi criado."
  value       = try(aws_iam_instance_profile.this[0].arn, null)
}

output "permissions_boundary_arn" {
  description = "ARN da permissions boundary aplicada à Role, ou nulo quando não configurada."
  value       = var.permissions_boundary_arn
}
