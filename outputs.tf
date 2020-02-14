output "tfe_public_ip" {
  value = aws_instance.tfe.*.public_ip
}

output "database_password" {
  value = "${random_string.database_password.result}"
}

output "database_username" {
  value = "${var.tfe_database_username}"
}

output "database_endpoint" {
  value = "${aws_rds_cluster.tfe.endpoint}"
}

output "database_name" {
  value = "${var.tfe_database_name}"
}

output "s3_bucket" {
  value = "${aws_s3_bucket.tfe_objects.id}"
}

output "s3_region" {
  value = "${aws_s3_bucket.tfe_objects.region}"
}

output "aws_access_key_id" {
  value = aws_iam_access_key.tfe_objects.id
}

output "aws_secret_access_key" {
  value = aws_iam_access_key.tfe_objects.secret
}