output "security_group_name" {
  description = "Nome do Security Group seguindo o padrão organizacional."
  value       = local.resource_name
}

output "security_group_arn" {
  description = "ARN do Security Group criado."
  value       = aws_security_group.this.arn
}

output "security_group_id" {
  description = "ID do Security Group criado."
  value       = aws_security_group.this.id
}
