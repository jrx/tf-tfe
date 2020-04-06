output "database_name" {
  value = aws_rds_cluster.tfe.database_name
}

output "endpoint" {
  value = aws_rds_cluster.tfe.endpoint
}

output "database_password" {
  value = random_string.database_password.result
}