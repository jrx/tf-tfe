resource "random_string" "redis_password" {
  length  = 40
  special = false
}

resource "aws_elasticache_subnet_group" "tfe" {
  name       = "tfe-test-elasticache"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_replication_group" "tfe" {
  node_type                     = "cache.m5.large"
  replication_group_id          = "${var.cluster_name}-tfe"
  replication_group_description = "External Redis for TFE."

  apply_immediately          = true
  at_rest_encryption_enabled = true
  auth_token                 = random_string.redis_password.id
  automatic_failover_enabled = true
  availability_zones         = var.availability_zones
  engine                     = "redis"
  engine_version             = "5.0.6"
  number_cache_clusters      = length(var.availability_zones)
  parameter_group_name       = "default.redis5.0"
  port                       = 7480
  security_group_ids         = var.vpc_security_group_ids
  subnet_group_name          = aws_elasticache_subnet_group.tfe.name
  transit_encryption_enabled = true
}