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

output "ssh_rule_ids" {
  description = "IDs das regras de ingress SSH."
  value       = [for _, r in aws_vpc_security_group_ingress_rule.ssh : r.id]
}

output "http_rule_ids" {
  description = "IDs das regras de ingress HTTP."
  value       = [for _, r in aws_vpc_security_group_ingress_rule.http : r.id]
}

output "https_rule_ids" {
  description = "IDs das regras de ingress HTTPS."
  value       = [for _, r in aws_vpc_security_group_ingress_rule.https : r.id]
}

output "custom_tcp_ipv4_rule_ids" {
  description = "IDs das regras de ingress TCP customizadas (IPv4)."
  value       = [for _, r in aws_vpc_security_group_ingress_rule.custom_tcp_ipv4 : r.id]
}

output "custom_tcp_ipv6_rule_ids" {
  description = "IDs das regras de ingress TCP customizadas (IPv6)."
  value       = [for _, r in aws_vpc_security_group_ingress_rule.custom_tcp_ipv6 : r.id]
}

output "self_ingress_rule_id" {
  description = "ID da regra de ingress self (se criada)."
  value       = try(aws_vpc_security_group_ingress_rule.self_all[0].id, null)
}

output "egress_all_ipv4_rule_id" {
  description = "ID da regra de egress permitir tudo IPv4 (se criada)."
  value       = try(aws_vpc_security_group_egress_rule.all_ipv4[0].id, null)
}

output "egress_all_ipv6_rule_id" {
  description = "ID da regra de egress permitir tudo IPv6 (se criada)."
  value       = try(aws_vpc_security_group_egress_rule.all_ipv6[0].id, null)
}

output "egress_custom_ipv4_rule_ids" {
  description = "IDs das regras de egress customizadas (IPv4)."
  value       = [for _, r in aws_vpc_security_group_egress_rule.custom_ipv4 : r.id]
}

output "egress_custom_ipv6_rule_ids" {
  description = "IDs das regras de egress customizadas (IPv6)."
  value       = [for _, r in aws_vpc_security_group_egress_rule.custom_ipv6 : r.id]
}
