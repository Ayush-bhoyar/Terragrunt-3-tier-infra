output "rds_endpoint" {
  value       = aws_db_instance.mysql_rds.address
  description = "RDS instance endpoint address"
}

output "rds_name" {
  value = aws_db_instance.mysql_rds.db_name
}