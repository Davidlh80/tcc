output "security_group_id" {
  description = "ID do Security Group criado."
  value       = aws_security_group.this.id
}

output "security_group_arn" {
  description = "ARN do Security Group criado."
  value       = aws_security_group.this.arn
}

output "security_group_name" {
  description = "Nome do Security Group criado."
  value       = aws_security_group.this.name
}

output "security_group_vpc_id" {
  description = "ID da VPC associada ao Security Group."
  value       = aws_security_group.this.vpc_id
}

output "security_group_ingress_rules" {
  description = "Regras de entrada efetivamente aplicadas ao Security Group."
  value       = var.ingress_rules
}

output "security_group_egress_rules" {
  description = "Regras de saída efetivamente aplicadas ao Security Group."
  value       = var.egress_rules
}
