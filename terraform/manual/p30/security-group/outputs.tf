output "security_group_name" {
  description = "Nomes dos security groups, indexados por backend, rds e redis."
  value = {
    backend = aws_security_group.backend.name
    rds     = aws_security_group.rds.name
    redis   = aws_security_group.redis.name
  }
}

output "security_group_arn" {
  description = "ARNs dos security groups, indexados por backend, rds e redis."
  value = {
    backend = aws_security_group.backend.arn
    rds     = aws_security_group.rds.arn
    redis   = aws_security_group.redis.arn
  }
}

output "security_group_id" {
  description = "IDs dos security groups, indexados por backend, rds e redis."
  value = {
    backend = aws_security_group.backend.id
    rds     = aws_security_group.rds.id
    redis   = aws_security_group.redis.id
  }
}
