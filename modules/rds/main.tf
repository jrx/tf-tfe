resource "random_string" "database_password" {
  length  = 40
  special = false
}

resource "aws_db_subnet_group" "tfe" {
  name_prefix = "${var.cluster_name}-tfe"
  subnet_ids  = var.subnet_ids

  tags = {
    Name = "tfe subnet group"
  }
}

resource "aws_rds_cluster" "tfe" {
  cluster_identifier_prefix = "${var.cluster_name}-tfe"
  engine                    = "aurora-postgresql"
  database_name             = var.tfe_database_name
  master_username           = var.tfe_database_username
  master_password           = random_string.database_password.result
  db_subnet_group_name      = aws_db_subnet_group.tfe.name
  backup_retention_period   = 5
  preferred_backup_window   = "07:00-09:00"
  vpc_security_group_ids    = var.vpc_security_group_ids
  final_snapshot_identifier = "${var.cluster_name}-tfe-final"
  skip_final_snapshot       = true
}

resource "aws_rds_cluster_instance" "tfe1" {
  apply_immediately    = true
  cluster_identifier   = aws_rds_cluster.tfe.id
  identifier_prefix    = "${var.cluster_name}tfe1"
  engine               = "aurora-postgresql"
  instance_class       = "db.r5.large"
  db_subnet_group_name = aws_db_subnet_group.tfe.name
}
