output "policy_arn" {
  description = "ARN of the created IAM policy."
  value       = aws_iam_policy.this.arn
}

output "policy_name" {
  description = "Name of the created IAM policy."
  value       = aws_iam_policy.this.name
}

output "policy_path" {
  description = "Path of the created IAM policy."
  value       = aws_iam_policy.this.path
}

output "policy_document_json" {
  description = "Rendered IAM policy document in JSON."
  value       = aws_iam_policy.this.policy
  sensitive   = false
}

output "attached_roles" {
  description = "Roles to which the policy is attached."
  value       = sort(var.attach_to_roles)
}

output "attached_users" {
  description = "Users to which the policy is attached."
  value       = sort(var.attach_to_users)
}

output "attached_groups" {
  description = "Groups to which the policy is attached."
  value       = sort(var.attach_to_groups)
}

output "attachment_count_total" {
  description = "Total number of attachments created across roles, users, and groups."
  value       = length(var.attach_to_roles) + length(var.attach_to_users) + length(var.attach_to_groups)
}
