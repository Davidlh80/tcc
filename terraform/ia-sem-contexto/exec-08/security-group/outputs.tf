output "security_group_id" {
  description = "ID do Security Group."
  value       = aws_security_group.this.id
}

output "security_group_arn" {
  description = "ARN do Security Group."
  value       = aws_security_group.this.arn
}

output "security_group_name" {
  description = "Nome do Security Group."
  value       = aws_security_group.this.name
}

output "security_group_vpc_id" {
  description = "ID da VPC associada ao Security Group."
  value       = aws_security_group.this.vpc_id
}

output "security_group_ingress_effective" {
  description = "Regras de ingress efetivas no Security Group (após criação)."
  value       = aws_security_group.this.ingress
}

output "security_group_egress_effective" {
  description = "Regras de egress efetivas no Security Group (após criação)."
  value       = aws_security_group.this.egress
}
