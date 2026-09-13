output "security_group_id" {
  description = "ID do Security Group criado."
  value       = aws_security_group.this.id
}

output "security_group_arn" {
  description = "ARN do Security Group criado."
  value       = aws_security_group.this.arn
}

output "security_group_name" {
  description = "Nome efetivo do Security Group (gerado a partir do name_prefix)."
  value       = aws_security_group.this.name
}

output "vpc_id" {
  description = "ID da VPC associada ao Security Group."
  value       = aws_security_group.this.vpc_id
}
