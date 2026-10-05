output "security_group_id" {
  description = "ID do security group."
  value       = aws_security_group.app.id
}

output "security_group_arn" {
  description = "ARN do security group."
  value       = aws_security_group.app.arn
}
