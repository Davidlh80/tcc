output "security_group_name" {
  description = "security_group_name do recurso criado."
  value       = aws_security_group.this.name
}

output "security_group_arn" {
  description = "security_group_arn do recurso criado."
  value       = aws_security_group.this.arn
}

output "security_group_id" {
  description = "security_group_id do recurso criado."
  value       = aws_security_group.this.id
}
