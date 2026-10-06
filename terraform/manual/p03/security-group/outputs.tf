output "security_group_id" {
  description = "ID of the Security Group."
  value       = aws_security_group.this.id
}

output "security_group_arn" {
  description = "ARN of the Security Group."
  value       = aws_security_group.this.arn
}

output "security_group_name" {
  description = "Name of the Security Group."
  value       = aws_security_group.this.name
}
