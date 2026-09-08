output "security_group_id" {
  description = "ID of the created Security Group."
  value       = aws_security_group.this.id
}

output "security_group_arn" {
  description = "ARN of the created Security Group."
  value       = aws_security_group.this.arn
}

output "security_group_name" {
  description = "Name of the created Security Group."
  value       = aws_security_group.this.name
}

output "security_group_vpc_id" {
  description = "VPC ID associated with the Security Group."
  value       = aws_security_group.this.vpc_id
}

output "ingress_rule_ids" {
  description = "List of ingress rule IDs associated with the Security Group."
  value       = [for r in aws_security_group_rule.ingress : r.id]
}

output "egress_rule_ids" {
  description = "List of egress rule IDs associated with the Security Group."
  value       = [for r in aws_security_group_rule.egress : r.id]
}

output "ingress_rules_count" {
  description = "Number of ingress rules created."
  value       = length(aws_security_group_rule.ingress)
}

output "egress_rules_count" {
  description = "Number of egress rules created."
  value       = length(aws_security_group_rule.egress)
}

output "tags" {
  description = "All tags applied to the Security Group."
  value       = aws_security_group.this.tags
}
