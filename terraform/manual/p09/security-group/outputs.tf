output "ID" {
  description = "Security groups' id"
  value       = aws_security_group.template_sg.id
}

output "arn" {
  description = "Security groups' ARN"
  value       = aws_security_group.template_sg.arn
}

output "resource_name" {
  description = "Security groups' name"
  value       = aws_security_group.template_sg.name
}
