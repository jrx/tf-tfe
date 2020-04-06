output "tfe_public_ip" {
  value = aws_instance.tfe.*.public_ip
}

output "tfe_hostname" {
  value = local.tfe_hostname
}

output "database_password" {
  value = module.rds.database_password
}

output "database_username" {
  value = var.tfe_database_username
}

output "database_endpoint" {
  value = module.rds.endpoint
}

output "database_name" {
  value = module.rds.database_name
}

output "s3_bucket" {
  value = module.s3.bucket_id
}

output "s3_region" {
  value = module.s3.region
}

output "aws_access_key_id" {
  value = aws_iam_access_key.tfe_objects.id
}

output "aws_secret_access_key" {
  value = aws_iam_access_key.tfe_objects.secret
}