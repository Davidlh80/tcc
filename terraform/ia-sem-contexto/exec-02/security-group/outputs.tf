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

output "ingress_rule_ids" {
  description = "Mapa de IDs das regras de ingress criadas, indexadas pela chave composta."
  value       = { for k, r in aws_security_group_rule.ingress : k => r.id }
}

output "egress_rule_ids" {
  description = "Mapa de IDs das regras de egress criadas, indexadas pela chave composta."
  value       = { for k, r in aws_security_group_rule.egress : k => r.id }
}
