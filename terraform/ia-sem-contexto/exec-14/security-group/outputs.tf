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

output "vpc_id" {
  description = "ID da VPC associada ao Security Group."
  value       = aws_security_group.this.vpc_id
}

output "ingress_rule_count" {
  description = "Quantidade de regras de entrada aplicadas."
  value       = length(var.ingress_rules)
}

output "egress_rule_count" {
  description = "Quantidade de regras de saída aplicadas."
  value       = length(var.egress_rules)
}
