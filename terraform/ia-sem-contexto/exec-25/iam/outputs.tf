output "role_arn" {
  description = "ARN da IAM role provisionada."
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "Nome da IAM role provisionada."
  value       = aws_iam_role.this.name
}

output "role_unique_id" {
  description = "Identificador unico (unique ID) da IAM role."
  value       = aws_iam_role.this.unique_id
}

output "policy_arn" {
  description = "ARN da IAM policy anexada a role."
  value       = aws_iam_policy.this.arn
}

output "policy_name" {
  description = "Nome da IAM policy anexada a role."
  value       = aws_iam_policy.this.name
}

output "policy_attachment_id" {
  description = "ID do attachment entre a policy e a role."
  value       = aws_iam_role_policy_attachment.this.id
}

output "account_id" {
  description = "Account ID AWS usado para provisionar os recursos."
  value       = data.aws_caller_identity.current.account_id
}
