output "security_group_name" {
  description = "Nome do Security Group, seguindo o padrão <ambiente>-<sistema>-sg-<finalidade>."
  value       = aws_security_group.this.name
}

output "security_group_arn" {
  description = "ARN do Security Group."
  value       = aws_security_group.this.arn
}

output "security_group_id" {
  description = "ID do Security Group."
  value       = aws_security_group.this.id
}
