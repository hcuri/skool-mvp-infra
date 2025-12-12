output "db_endpoint" {
  description = "RDS endpoint address"
  value       = aws_db_instance.this.address
}

output "db_name" {
  description = "Database name"
  value       = aws_db_instance.this.db_name
}

output "db_username" {
  description = "Database master username"
  value       = aws_db_instance.this.username
}

output "security_group_id" {
  description = "Security group ID controlling DB access"
  value       = aws_security_group.db.id
}
