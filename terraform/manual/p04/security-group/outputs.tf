output "security_group_id" {
  description = "ID do sg"
  value       = aws_security_group.this.id
}

output "security_group_arn" {
  description = "ARN do sg"
  value       = aws_security_group.this.arn
}

output "security_group_name" {
  description = "nome do sg"
  value       = aws_security_group.this.name
}
