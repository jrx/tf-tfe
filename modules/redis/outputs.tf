output "redis_host" {
  value = aws_elasticache_replication_group.tfe.primary_endpoint_address
}

output "redis_port" {
  value = aws_elasticache_replication_group.tfe.port
}

output "redis_pass" {
  value = aws_elasticache_replication_group.tfe.auth_token
}