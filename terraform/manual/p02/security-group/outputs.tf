output "security_group_id" {
  description = "ID do Security Group criado"
  value       = aws_security_group.this.id
}

output "security_group_name" {
  description = "Nome do Security Group"
  value       = aws_security_group.this.name
}

output "security_group_arn" {
  description = "ARN do Security Group"
  value       = aws_security_group.this.arn
}

output "security_group_vpc_id" {
  description = "ID da VPC associada ao Security Group"
  value       = aws_security_group.this.vpc_id
}

output "ssh_allowed_cidr" {
  description = "CIDR autorizado para acesso SSH"
  value       = aws_vpc_security_group_ingress_rule.ssh.cidr_ipv4
}

output "ssh_ingress_rule_id" {
  description = "ID da regra de entrada SSH"
  value       = aws_vpc_security_group_ingress_rule.ssh.security_group_rule_id
}

output "egress_rule_id" {
  description = "ID da regra de saída IPv4"
  value       = aws_vpc_security_group_egress_rule.all_ipv4.security_group_rule_id
}
