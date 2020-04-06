output "bucket_id" {
  value = aws_s3_bucket.tfe_objects.id
}

output "region" {
  value = aws_s3_bucket.tfe_objects.region
}
